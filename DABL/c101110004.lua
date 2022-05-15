--ＢＦ－幻耀のスズリ
function c101110004.initial_effect(c)
	aux.AddCodeList(c,9012916)
	--Search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101110004,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c101110004.thtg)
	e1:SetOperation(c101110004.thop)
	c:RegisterEffect(e1)
	--Special Summon token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101110004,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101110004)
	e2:SetCost(c101110004.spcost)
	e2:SetTarget(c101110004.sptg)
	e2:SetOperation(c101110004.spop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(101110004,ACTIVITY_SPSUMMON,c101110004.counterfilter)
end
function c101110004.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or c:IsType(TYPE_SYNCHRO)
end
function c101110004.thfilter(c)
	return aux.IsCodeListed(c,9012916) and not c:IsCode(101110004) and c:IsAbleToHand()
end
function c101110004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101110004.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101110004.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101110004.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101110004.cfilter(c)
	return Duel.GetMZoneCount(tp,c)>0
end
function c101110004.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(101110004,tp,ACTIVITY_SPSUMMON)==0
		and Duel.CheckReleaseGroup(tp,c101110004.cfilter,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c101110004.cfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101110004.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101110004.splimit(e,c)
	return not c:IsType(TYPE_SYNCHRO) and c:IsLocation(LOCATION_EXTRA)
end
function c101110004.lizfilter(e,c)
	return not c:IsOriginalType(TYPE_SYNCHRO)
end
function c101110004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,101110104,0,TYPES_TOKEN_MONSTER+TYPE_TUNER,700,700,2,RACE_WINGEDBEAST,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,1,tp,700)
end
function c101110004.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,101110104,0,TYPES_TOKEN_MONSTER+TYPE_TUNER,700,700,2,RACE_WINGEDBEAST,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,101110104)
	if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
		Duel.Damage(tp,700,REASON_EFFECT)
	end
end
