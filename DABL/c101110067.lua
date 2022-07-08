--禁呪アラマティア
function c101110067.initial_effect(c)
	aux.AddCodeList(c,3285552)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Special Summon 1 "Adventurer Token"
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101110067,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,101110067)
	e2:SetTarget(c101110067.tktg)
	e2:SetOperation(c101110067.tkop)
	c:RegisterEffect(e2)
	--Special Summon 1 "Adventurer Token"
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101110067,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,101110067+100)
	e3:SetCondition(c101110067.spcon)
	e3:SetTarget(c101110067.sptg)
	e3:SetOperation(c101110067.spop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(101110067,ACTIVITY_SPSUMMON,c101110067.counterfilter)
end
function c101110067.counterfilter(c)
	return (c:IsCode(3285552) or aux.IsCodeListed(c,3285552))
end
function c101110067.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(101110028,tp,ACTIVITY_SPSUMMON)==0 end
	--Cannot Special Summon from the same turn, except "Adventurer Token" and monsters that mention it
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101110067.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101110067.splimit(e,c)
	return not (c:IsCode(3285552) or (aux.IsCodeListed(c,3285552) and c:IsType(TYPE_MONSTER)))
end
function c101110067.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,3285552,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FAIRY,ATTRIBUTE_EARTH)
	local b2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,3285552,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FAIRY,ATTRIBUTE_EARTH,POS_FACEUP,1-tp)
	if chk==0 then return (b1 or b2)
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,PLAYER_ALL,0)
end
function c101110067.tkop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,3285552,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FAIRY,ATTRIBUTE_EARTH)
	local b2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,3285552,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FAIRY,ATTRIBUTE_EARTH,POS_FACEUP,1-tp)
	local sel=0
	if b1 or b2 then
		if b1 and b2 then
			sel=Duel.SelectOption(tp,aux.Stringid(101110067,2),aux.Stringid(101110067,3))
		elseif b2 then
			sel=1
		end
		local to=tp
		if sel==1 then to=1-tp end
		local token=Duel.CreateToken(tp,101110167)
		if Duel.SpecialSummon(token,0,tp,to,false,false,POS_FACEUP)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,1,nil)
			if #g>0 then
				Duel.BreakEffect()
				Duel.SendtoGrave(g,REASON_EFFECT)
			end
		end
	end
end
function c101110067.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c101110067.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101110067.cfilter,1,nil,tp)
end
function c101110067.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,3285552,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FAIRY,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c101110067.spop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,3285552,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FAIRY,ATTRIBUTE_EARTH)
	local b2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,3285552,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FAIRY,ATTRIBUTE_EARTH,POS_FACEUP,1-tp)
	local sel=0
	if b1 or b2 then
		if b1 and b2 then
			sel=Duel.SelectOption(tp,aux.Stringid(101110067,2),aux.Stringid(101110067,3))
		elseif b2 then
			sel=1
		end
		local to=tp
		if sel==1 then to=1-tp end
		local token=Duel.CreateToken(tp,3285552)
		Duel.SpecialSummon(token,0,tp,to,false,false,POS_FACEUP)
	end
end