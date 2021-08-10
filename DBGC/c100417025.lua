--アラメシアの儀
function c100417025.initial_effect(c)
	aux.AddCodeList(c,100417125)
	-- Special Summon token
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100417025,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c100417025.spcon)
	e1:SetCost(c100417025.spcost)
	e1:SetTarget(c100417025.sptg)
	e1:SetOperation(c100417025.spop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(100417025,ACTIVITY_CHAIN,c100417025.actfilter)
end
function c100417025.actfilter(re,tp,cid)
	local rc=re:GetHandler()
	return not (re:IsActiveType(TYPE_MONSTER) and rc:IsOnField() and not rc:IsSummonType(SUMMON_TYPE_SPECIAL))
end
function c100417025.filter(c)
	return c:IsFaceup() and c:IsCode(100417125)
end
function c100417025.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c100417025.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c100417025.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(100417025,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c100417025.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c100417025.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc:IsOnField() and not rc:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c100417025.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,100417125,0,TYPES_TOKEN,2000,2000,4,RACE_FAIRY,ATTRIBUTE_EARTH) 
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c100417025.plfilter(c)
	return c:IsCode(100417029) and not c:IsForbidden()
end
function c100417025.cfilter2(c)
	return c:IsCode(100417029) and c:IsFaceup()
end
function c100417025.spop(e,tp,eg,ep,ev,re,r,rp)
	if not c100417025.sptg(e,tp,eg,ep,ev,re,r,rp,0) then return end
	local token=Duel.CreateToken(tp,100417125)
	if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and not Duel.IsExistingMatchingCard(c100417025.cfilter2,tp,LOCATION_SZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c100417025.plfilter,tp,LOCATION_DECK,0,1,nil) 
		and Duel.SelectYesNo(tp,aux.Stringid(100417025,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,c100417025.plfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		if tc then
			Duel.BreakEffect()
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end