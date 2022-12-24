--千六百七十七万工房
function c100298005.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100298005,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e2:SetCountLimit(1)
	e2:SetTarget(c100298005.changetg)
	e2:SetOperation(c100298005.changeop)
	c:RegisterEffect(e2)
end
function c100298005.tgfilter(c)
	return c:IsFaceup() and (not c:IsRace(RACE_MACHINE) or c:GetAttribute()~=ATTRIBUTE_ALL&~ATTRIBUTE_DIVINE)
end
function c100298005.changetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c100298005.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100298005.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c100298005.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c100298005.changeop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local c=e:GetHandler()
		--Also treated as LIGHT, DARK, EARTH, WATER, FIRE, and WIND
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_ATTRIBUTE)
		e1:SetValue(ATTRIBUTE_ALL&~ATTRIBUTE_DIVINE)
		tc:RegisterEffect(e1)
		--Becomes a Machine monster
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetValue(RACE_MACHINE)
		tc:RegisterEffect(e2)
	end
end