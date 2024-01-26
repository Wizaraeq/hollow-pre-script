--ウェイクアップ・センチュリオン！
local s,id,o=GetID()
function s.initial_effect(c)
	--Special Summon 1 "Centur-Ion Token"
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END+TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.tokencond)
	e1:SetTarget(s.tokentg)
	e1:SetOperation(s.tokenop)
	c:RegisterEffect(e1)
	--Send 1 "Centur-Ion" card from your Deck to the GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+o)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.tgytg)
	e2:SetOperation(s.tgyop)
	c:RegisterEffect(e2)
end
function s.cfilter(c)
	return c:GetSequence()<5 and c:IsFaceup() and c:GetOriginalType()&TYPE_MONSTER~=0
end
function s.tokencond(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_SZONE,0,1,nil)
end
function s.tokentg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lv4=Duel.IsPlayerCanSpecialSummonMonster(tp,id+o,0x1a2,TYPES_TOKEN_MONSTER,0,0,4,RACE_PYRO,ATTRIBUTE_DARK,POS_FACEUP)
	local lv8=Duel.IsPlayerCanSpecialSummonMonster(tp,id+o,0x1a2,TYPES_TOKEN_MONSTER,0,0,8,RACE_PYRO,ATTRIBUTE_DARK,POS_FACEUP)
	if chk==0 then return (lv4 or lv8) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local levels={}
	if lv4 then table.insert(levels,4) end
	if lv8 then table.insert(levels,8) end
	local lvl=Duel.AnnounceNumber(tp,table.unpack(levels))
	e:SetLabel(lvl)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.tokenop(e,tp,eg,ep,ev,re,r,rp)
	local lvl=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,id+o,0x1a2,TYPES_TOKEN_MONSTER,0,0,lvl,RACE_PYRO,ATTRIBUTE_DARK,POS_FACEUP) then return end
	local token=Duel.CreateToken(tp,id+o)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	e1:SetValue(lvl)
	token:RegisterEffect(e1,true)
	if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
		--Cannot be used as Fusion material
		local e2=e1:Clone()
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e2:SetValue(1)
		token:RegisterEffect(e2,true)
		--Cannot be used as Link material
		local e3=e2:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		token:RegisterEffect(e3,true)
	end
	Duel.SpecialSummonComplete()
end
function s.tgyfilter(c)
	return c:IsSetCard(0x1a2) and not c:IsCode(id) and c:IsAbleToGrave()
end
function s.tgytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgyfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.tgyop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgyfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end