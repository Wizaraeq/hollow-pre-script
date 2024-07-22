--Ｂ・Ｆ・Ｗ
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--serch
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+id)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(2)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	local g=Group.CreateGroup()
	aux.RegisterMergedDelayedEvent(c,id,EVENT_SUMMON_SUCCESS,g)
	aux.RegisterMergedDelayedEvent(c,id,EVENT_SPSUMMON_SUCCESS,g)
	--tuner
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(s.tntg)
	e4:SetOperation(s.tnop)
	c:RegisterEffect(e4)
end
function s.tgfilter(c,e,tp)
	return c:IsSetCard(0x12f)
		and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsControler(tp) and c:IsCanBeEffectTarget(e)
		and (chk or Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_DECK,0,1,nil,c:GetAttack()))
end
function s.cfilter(c,atk)
	local a=c:GetAttack()
	return a>=0 and a<atk and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x12f)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and s.tgfilter(chkc,e,tp) end
	local g=eg:Filter(s.tgfilter,nil,e,tp)
	if chk==0 then return g:GetCount()>0 end
	if g:GetCount()==1 then
		Duel.SetTargetCard(g:GetFirst())
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local tc=g:Select(tp,1,1,nil)
		Duel.SetTargetCard(tc)
	end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetAttack())
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function s.tfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT) and c:IsLevelAbove(1) and not c:IsType(TYPE_TUNER)
end
function s.tntg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.tfilter(chkc)  end
	if chk==0 then return Duel.IsExistingTarget(s.tfilter,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.tfilter,tp,LOCATION_MZONE,0,1,1,c)
end
function s.tnop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TUNER)
		e1:SetValue(s.tnval)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
	end
end
function s.tnval(e,c)
	return e:GetHandler():IsControler(c:GetControler())
end
