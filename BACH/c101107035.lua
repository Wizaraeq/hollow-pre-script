--凶導の白聖骸
function c101107035.initial_effect(c)
	c:EnableReviveLimit()
	-- Gain ATK
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101107035,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c101107035.atkcon)
	e1:SetTarget(c101107035.atktg)
	e1:SetOperation(c101107035.atkop)
	c:RegisterEffect(e1)
	-- Cannot be destroyed by battle
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c101107035.indtg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	-- Send to GY
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101107035,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,101107035)
	e3:SetCondition(c101107035.tgcon)
	e3:SetTarget(c101107035.tgtg)
	e3:SetOperation(c101107035.tgop)
	c:RegisterEffect(e3)
end
function c101107035.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c101107035.atkrescon(sg)
	return sg:IsExists(Card.IsAttackAbove,1,nil,1)
end
function c101107035.atkfilter(c,e)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function c101107035.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	local g=Duel.GetMatchingGroup(c101107035.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	if chk==0 then return g:CheckSubGroup(c101107035.atkrescon,2,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=g:SelectSubGroup(tp,c101107035.atkrescon,false,2,2)
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,2,0,0)
end
function c101107035.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	if tc1:IsFaceup() and tc1:IsRelateToEffect(e) and tc2:IsFaceup() and tc2:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101107035,1))
		local sg=g:Select(tp,1,1,nil)
		local tg=sg:GetFirst()
		if sg:GetFirst()==tc1 then atk=tc2:GetAttack()
		else atk=tc1:GetAttack() end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE)
		e1:SetValue(atk)
		tg:RegisterEffect(e1)
	end
end
function c101107035.indtg(e,c)
	return c:IsSetCard(0x145) and c:IsLevelAbove(8)
end
function c101107035.tgconfilter(c,tp)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsPreviousControler(1-tp)
end
function c101107035.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101107035.tgconfilter,1,nil,tp)
end
function c101107035.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_EXTRA)
end
function c101107035.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	Duel.ConfirmCards(tp,g)
	local tg=g:Filter(Card.IsAbleToGrave,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=tg:Select(tp,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
	Duel.ShuffleExtra(1-tp)
end