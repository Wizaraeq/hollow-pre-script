--エヴォルダー・リオス
function c101201018.initial_effect(c)
	--Set 1 "Evolutionary Bridge" or "Evo-Singularity" from the Deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101201018,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,101201018)
	e1:SetTarget(c101201018.settg)
	e1:SetOperation(c101201018.setop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--Send 1 FIRE Reptile or Dinosaur monster to the GY
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101201018,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,101201018+100)
	e3:SetCondition(c101201018.tgcon)
	e3:SetTarget(c101201018.tgtg)
	e3:SetOperation(c101201018.tgop)
	c:RegisterEffect(e3)
	--Register a flag when it is Normal Summoned or Special Summoned by a FIRE monster's effect
	local e3a=Effect.CreateEffect(c)
	e3a:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3a:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3a:SetCode(EVENT_SUMMON_SUCCESS)
	e3a:SetOperation(c101201018.regop)
	c:RegisterEffect(e3a)
	local e3b=e3a:Clone()
	e3b:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3b:SetCondition(c101201018.regcon)
	c:RegisterEffect(e3b)
end
function c101201018.setfilter(c)
	return c:IsCode(93504463,74100225) and c:IsSSetable()
end
function c101201018.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101201018.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c101201018.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c101201018.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end
function c101201018.tgcon(e)
	return e:GetHandler():GetFlagEffect(101201018)>0
end
function c101201018.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_REPTILE+RACE_DINOSAUR) and c:IsAbleToGrave()
end
function c101201018.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101201018.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c101201018.cfilter(c,lv,race)
	return c:IsFaceup() and ((not c:IsRace(race)) or (c:IsLevelAbove(1) and c:GetLevel()~=lv))
end
function c101201018.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sc=Duel.SelectMatchingCard(tp,c101201018.tgfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if sc and Duel.SendtoGrave(sc,REASON_EFFECT)>0 and sc:IsLocation(LOCATION_GRAVE) then
		local lv=sc:GetLevel()
		local race=sc:GetRace()
		local g=Duel.GetMatchingGroup(c101201018.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,lv,race)
		if #g>=2 and Duel.SelectYesNo(tp,aux.Stringid(101201018,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
			local sg=g:FilterSelect(tp,c101201018.cfilter,2,2,nil,lv,race)
			Duel.HintSelection(sg)
			Duel.BreakEffect()
			local c=e:GetHandler()
			for tc in aux.Next(sg) do
				--Level becomes the sent monster's level
				if tc:IsLevelAbove(1) then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_CHANGE_LEVEL)
					e1:SetValue(lv)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
				end
				--Type becomes the sent monster's type
				if not tc:IsRace(rac) then
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_CHANGE_RACE)
					e2:SetValue(race)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e2)
				end
			end
		end
	end
end
function c101201018.regcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsAttribute(ATTRIBUTE_FIRE)
end
function c101201018.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(101201018,RESET_EVENT+RESETS_STANDARD,0,1)
end
