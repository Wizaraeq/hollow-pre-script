--双天の獅使－阿吽
function c101112038.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x14f),2,true)
	--Apply effects if Fusion Summoned with specific materials
	local e1a=Effect.CreateEffect(c)
	e1a:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1a:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1a:SetCondition(c101112038.condition)
	e1a:SetOperation(c101112038.operation)
	c:RegisterEffect(e1a)
	--Material Check
	local e1b=Effect.CreateEffect(c)
	e1b:SetType(EFFECT_TYPE_SINGLE)
	e1b:SetCode(EFFECT_MATERIAL_CHECK)
	e1b:SetValue(c101112038.valcheck)
	e1b:SetLabelObject(e1a)
	c:RegisterEffect(e1b)
	--Special Summon 2 monsters if it is destroyed
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101112038,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(c101112038.spcon)
	e2:SetTarget(c101112038.sptg)
	e2:SetOperation(c101112038.spop)
	c:RegisterEffect(e2)
end
function c101112038.condition(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c101112038.valcheck(e,c)
	local g=c:GetMaterial()
	local flag=0
	if g:IsExists(Card.IsCode,1,nil,33026283) then flag=flag+1 end
	if g:IsExists(Card.IsCode,1,nil,284224) then flag=flag+2 end
	e:GetLabelObject():SetLabel(flag)
end
function c101112038.operation(e,tp,eg,ep,ev,re,r,rp)
	local flag=e:GetLabel()
	local c=e:GetHandler()
	if (flag&1)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_ATKCHANGE)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(c101112038.atktg)
		e1:SetCondition(c101112038.atkcon)
		e1:SetValue(3000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(101112038,2))
	end
	if (flag&2)>0 then
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(101112038,1))
		e2:SetCategory(CATEGORY_REMOVE)
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e2:SetRange(LOCATION_MZONE)
		e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
		e2:SetCountLimit(1)
		e2:SetCondition(c101112038.rmcon)
		e2:SetTarget(c101112038.rmtg)
		e2:SetOperation(c101112038.rmop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(101112038,3))
	end
end
function c101112038.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL
end
function c101112038.atktg(e,c)
	return c:IsSetCard(0x14f) and c:IsRelateToBattle()
end
function c101112038.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c101112038.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c101112038.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c101112038.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_FUSION)
end
function c101112038.spfilter1(c,e,tp)
	return c:IsCode(85360035) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c101112038.spfilter2,tp,LOCATION_DECK,0,1,c,e,tp)
end
function c101112038.spfilter2(c,e,tp)
	return c:IsCode(11759079) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101112038.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsExistingMatchingCard(c101112038.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c101112038.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2
		or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c101112038.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,c101112038.spfilter2,tp,LOCATION_DECK,0,1,1,g1:GetFirst(),e,tp)
	g1:Merge(g2)
	if g1:GetCount()==2 then
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		for tc in aux.Next(g1) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			tc:RegisterEffect(e2)
		end
		Duel.SpecialSummonComplete()
	end
end