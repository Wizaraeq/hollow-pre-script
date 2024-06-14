--メタル化・魔法反射装甲
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,101206070)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function s.costfilter(c,e,tp)
	return c:IsFaceup() and Duel.GetMZoneCount(tp,c,tp)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,c,c:GetLevel(),c:GetRace())
end
function s.spfilter(c,e,tp,mc,mcl,mcr)
	return not c:IsSummonableCard() and aux.IsCodeListed(c,101206070)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
		and c.enhacement_metalmorph_filter
		and c.enhacement_metalmorph_filter(mc,mcl,mcr)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,s.costfilter,1,nil,e,tp)
	end
	local rg=Duel.SelectReleaseGroup(tp,s.costfilter,1,1,nil,e,tp)
	Duel.Release(rg,REASON_COST)
	e:SetLabelObject(rg:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local mc=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,mc,mc:GetPreviousLevelOnField(),mc:GetPreviousRaceOnField()):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)>0 and c:IsRelateToEffect(e)
		and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		c:CancelToGrave(true)
		Duel.BreakEffect()
		Duel.Equip(tp,c,tc)
		--Add Equip limit
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(s.eqlimit)
		c:RegisterEffect(e1)
		--Atkup
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(400)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_EQUIP)
		e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e4:SetValue(s.efilter)
		c:RegisterEffect(e4)
		local e5=e4:Clone()
		e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e5:SetValue(s.efilter)
		c:RegisterEffect(e5)
	end
	tc:CompleteProcedure()
end
function s.eqlimit(e,c)
	return e:GetHandler():GetEquipTarget()==c
end
function s.efilter(e,re,rp)
	return re:IsActiveType(TYPE_MONSTER) or re:IsActiveType(TYPE_SPELL)
end