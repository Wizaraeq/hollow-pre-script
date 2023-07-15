--地縛戒隷 ジオグレムリーナ
function c101202031.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x21),aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_DARK),false)
	--Search 1 "Earthbound" monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101202031,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,101202031)
	e1:SetTarget(c101202031.thtg)
	e1:SetOperation(c101202031.thop)
	c:RegisterEffect(e1)
	--1 DARK Synchro Monster you control can attack directly this turn
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101202031,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101202031+100)
	e2:SetCondition(c101202031.dacon)
	e2:SetTarget(c101202031.datg)
	e2:SetOperation(c101202031.daop)
	c:RegisterEffect(e2)
	--Inflict damage to your opponent
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101202031,2))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,101202031+200)
	e3:SetTarget(c101202031.damtg)
	e3:SetOperation(c101202031.damop)
	c:RegisterEffect(e3)
end
function c101202031.thfilter(c)
	return c:IsSetCard(0x21) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c101202031.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101202031.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101202031.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101202031.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101202031.dacon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c101202031.dafilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsFaceup() and not c:IsHasEffect(EFFECT_DIRECT_ATTACK)
end
function c101202031.datg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101202031.dafilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101202031.dafilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101202031.dafilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101202031.daop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		--Can attack directly this turn
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c101202031.damfilter(c,e,tp)
	local rc=c:GetReasonEffect():GetHandler()
	return rc:IsSetCard(0x21) and c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousControler(1-tp) and c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED)
		and c:IsReason(REASON_EFFECT) and c:IsCanBeEffectTarget(e) and c:GetTextAttack()>0
end
function c101202031.damtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c101202031.damfilter(chkc,e,tp) end
	if chk==0 then return eg:IsExists(c101202031.damfilter,1,nil,e,tp) end
	local g=eg:Filter(c101202031.damfilter,nil,e,tp)
	local tc=nil
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		tc=g:Select(tp,1,1,nil):GetFirst()
	else
		tc=g:GetFirst()
	end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,tc:GetTextAttack())
end
function c101202031.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Damage(1-tp,tc:GetTextAttack(),REASON_EFFECT)
	end
end