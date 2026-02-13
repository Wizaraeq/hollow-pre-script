--ガガガマジシャン－ガガガマジック
local s,id,o=GetID()
function s.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.xyzlv(e,c,rc)
	return e:GetHandler():GetLevel()+e:GetLabel()*0x10000
end
function s.xyzfiltr(c,g)
	return c:IsSetCard(0x8f,0x54,0x59,0x82,0x206f,0x6d,0x48,0x107e,0x207e)
		and c:IsXyzSummonable(g,2,2)
end
function s.spfilter(c,e,tp,ec)
	if not (not c:IsCode(id) and c:IsSetCard(0x8f,0x54,0x59,0x82) and c:IsLevelAbove(1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) then return false end
	local e1=nil
	local e2=nil
	if ec:IsLevelAbove(1) then
		e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_XYZ_LEVEL)
		e1:SetValue(s.xyzlv)
		e1:SetLabel(ec:GetLevel())
		c:RegisterEffect(e1,true)
	end
	if c:IsLevelAbove(1) then
		e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_XYZ_LEVEL)
		e2:SetValue(s.xyzlv)
		e2:SetLabel(c:GetLevel())
		ec:RegisterEffect(e2,true)
	end
	local res=Duel.IsExistingMatchingCard(s.xyzfiltr,tp,LOCATION_EXTRA,0,1,nil,Group.FromCards(c,ec))
	if e1 then e1:Reset() end
	if e2 then e2:Reset() end
	return res
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() then return end
	if not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,c):GetFirst()
	if tc then
		local g=Group.FromCards(c,tc)
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)==2
			and g:IsExists(Card.IsLocation,2,nil,LOCATION_MZONE)
			and g:IsExists(Card.IsFaceup,2,nil) then
			local e1=nil
			local e2=nil
			if c:IsLevelAbove(1) then
				e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_XYZ_LEVEL)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(s.xyzlv)
				e1:SetLabel(c:GetLevel())
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1,true)
			end
			if tc:IsLevelAbove(1) then 
				e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_XYZ_LEVEL)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetValue(s.xyzlv)
				e2:SetLabel(tc:GetLevel())
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e2,true)
			end
			Duel.AdjustAll()
			local xyzg=Duel.GetMatchingGroup(s.xyzfiltr,tp,LOCATION_EXTRA,0,nil,g)
			if xyzg:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
				Duel.XyzSummon(tp,xyz,g)
			else
				if e1 then e1:Reset() end
				if e2 then e2:Reset() end
			end
		end
	end
end
