--幻惑の眼
function c100207001.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100207001,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c100207001.condition)
	e1:SetTarget(c100207001.target)
	e1:SetOperation(c100207001.activate)
	c:RegisterEffect(e1)
end
function c100207001.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER+RACE_ILLUSION)
end
function c100207001.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100207001.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100207001.filter(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged()
end
function c100207001.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ak=Duel.GetAttacker()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup()
		and (e:GetLabel()==2 and chkc:IsControlerCanBeChanged() or e:GetLabel()==3 and chkc~=ak) end
	if chk==0 then return true end
	local b2=Duel.GetTurnPlayer()==1-tp
		and Duel.IsExistingTarget(c100207001.filter,tp,0,LOCATION_MZONE,1,nil)
	local b3=Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE) and ak:IsControler(1-tp)
		and Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,ak)
	local op=aux.SelectFromOptions(tp,
			{true,aux.Stringid(100207001,1)},
			{b2,aux.Stringid(100207001,2)},
			{b3,aux.Stringid(100207001,3)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(0)
		e:SetProperty(0)
	elseif op==2 then
		e:SetCategory(CATEGORY_CONTROL)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local g=Duel.SelectTarget(tp,c100207001.filter,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
	else
		e:SetCategory(0)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,ak)
	end
end
function c100207001.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_SPELLCASTER+RACE_ILLUSION))
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	elseif op==2 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.GetControl(tc,tp,PHASE_END,1)
		end
	else
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			local ak=Duel.GetAttacker()
			if ak:IsAttackable() and not ak:IsImmuneToEffect(e) then
				Duel.CalculateDamage(ak,tc)
			end
		end
	end
end