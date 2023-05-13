--異界共鳴－シンクロ・フュージョン
function c100207025.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100207025+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c100207025.cost)
	e1:SetTarget(c100207025.target)
	e1:SetOperation(c100207025.activate)
	e1:SetLabel(0)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(100207025,ACTIVITY_SPSUMMON,c100207025.counterfilter)
end
function c100207025.counterfilter(c)
	return c:GetSummonLocation()~=LOCATION_EXTRA or c:IsType(TYPE_SYNCHRO+TYPE_FUSION)
end
function c100207025.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c100207025.cfilter1(c,e,tp)
	return c:IsFaceup() and c:GetOriginalType()&TYPE_TUNER~=0 and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c100207025.cfilter2,tp,LOCATION_MZONE,0,1,c,e,tp,c)
end
function c100207025.cfilter2(c,e,tp,tun)
	if not (c:IsFaceup() and not c:IsType(TYPE_TUNER) and c:IsAbleToGraveAsCost()) then return false end
	local g=Group.FromCards(tun,c)
	local chk=Duel.GetLocationCountFromEx(tp,tp,g,TYPE_FUSION+TYPE_SYNCHRO)>1 and Duel.IsExistingMatchingCard(c100207025.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,g)
		and Duel.IsExistingMatchingCard(c100207025.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,g)
	return chk
end
function c100207025.filter1(c,e,tp,mg)
	local m1=mg:GetFirst()
	local m2=mg:GetNext()
	m1:AssumeProperty(ASSUME_LEVEL,m1:GetOriginalLevel())
	m2:AssumeProperty(ASSUME_LEVEL,m2:GetOriginalLevel())
	m1:AssumeProperty(ASSUME_RACE,m1:GetRaceInGrave())
	m2:AssumeProperty(ASSUME_RACE,m2:GetRaceInGrave())
	m1:AssumeProperty(ASSUME_ATTRIBUTE,m1:GetAttributeInGrave())
	m2:AssumeProperty(ASSUME_ATTRIBUTE,m2:GetAttributeInGrave())
	m1:AssumeProperty(ASSUME_ATTACK,m1:GetTextAttack())
	m2:AssumeProperty(ASSUME_ATTACK,m2:GetTextAttack())
	m1:AssumeProperty(ASSUME_DEFENSE,m1:GetTextDefense())
	m2:AssumeProperty(ASSUME_DEFENSE,m2:GetTextDefense())
	local g=Group.FromCards(m1,m2)
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:CheckFusionMaterial(g) and not c:IsCode(41209827) and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0
end
function c100207025.filter2(c,e,tp,mg)
	local m1=mg:GetFirst()
	local m2=mg:GetNext()
	m1:AssumeProperty(ASSUME_LEVEL,m1:GetOriginalLevel())
	m2:AssumeProperty(ASSUME_LEVEL,m2:GetOriginalLevel())
	m1:AssumeProperty(ASSUME_RACE,m1:GetRaceInGrave())
	m2:AssumeProperty(ASSUME_RACE,m2:GetRaceInGrave())
	m1:AssumeProperty(ASSUME_ATTRIBUTE,m1:GetAttributeInGrave())
	m2:AssumeProperty(ASSUME_ATTRIBUTE,m2:GetAttributeInGrave())
	m1:AssumeProperty(ASSUME_ATTACK,m1:GetTextAttack())
	m2:AssumeProperty(ASSUME_ATTACK,m2:GetTextAttack())
	m1:AssumeProperty(ASSUME_DEFENSE,m1:GetTextDefense())
	m2:AssumeProperty(ASSUME_DEFENSE,m2:GetTextDefense())
	local g=Group.FromCards(m1,m2)
	return c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSynchroSummonable(nil,g) and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0
end
function c100207025.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.GetCustomActivityCount(100207025,tp,ACTIVITY_SPSUMMON)==0 and Duel.IsExistingMatchingCard(c100207025.cfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tun=Duel.SelectMatchingCard(tp,c100207025.cfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local nt=Duel.SelectMatchingCard(tp,c100207025.cfilter2,tp,LOCATION_MZONE,0,1,1,tun,e,tp,tun):GetFirst()
	Duel.SendtoGrave(Group.FromCards(tun,nt),REASON_COST)
	Duel.SetTargetCard(Duel.GetOperatedGroup())
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c100207025.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c100207025.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_SYNCHRO+TYPE_FUSION) and c:IsLocation(LOCATION_EXTRA)
end
function c100207025.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
	local mg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or not (mg and mg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)==2 and Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_FUSION+TYPE_SYNCHRO)>1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local fc=Duel.SelectMatchingCard(tp,c100207025.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg):GetFirst()
	if not fc then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c100207025.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg):GetFirst()
	if not sc then return end
	local g=Group.FromCards(fc,sc)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end