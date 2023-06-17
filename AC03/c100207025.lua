--異界共鳴－シンクロ・フュージョン
--Harmonic Synchro Fusion
--coded by Lyris
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.rfilter)
end
function s.rfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or c:IsType(TYPE_FUSION+TYPE_SYNCHRO)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function s.filter(c,e,tp)
	return c:IsType(TYPE_FUSION+TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.xfilter(c)
	return not c:IsType(TYPE_TUNER)
end
function s.chk(g,e,tp)
	if not (g:IsExists(Card.IsType,1,nil,TYPE_TUNER) and g:IsExists(s.xfilter,1,nil)
		and Duel.GetLocationCountFromEx(tp,tp,g,TYPE_FUSION)
		&Duel.GetLocationCountFromEx(tp,tp,g,TYPE_SYNCHRO)>1) then return false end
	local sg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_EXTRA,0,nil,e,tp)
	return sg:IsExists(s.filter1,1,nil,e,tp,g)
		and sg:IsExists(s.filter2,1,nil,e,tp,g)
end
function s.filter1(c,e,tp,mg)
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
	return c:IsType(TYPE_FUSION) and c:CheckFusionMaterial(g) and not c:IsCode(41209827)
end
function s.filter2(c,e,tp,mg)
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
	return c:IsType(TYPE_SYNCHRO) and c:IsSynchroSummonable(nil,g)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return mg:CheckSubGroup(s.chk,2,2,e,tp)
		and Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=mg:SelectSubGroup(tp,s.chk,false,2,2,e,tp)
	Duel.SendtoGrave(g,REASON_COST)
	g:KeepAlive()
	e:SetLabelObject(g)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_OATH+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.limit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.limit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_FUSION+TYPE_SYNCHRO)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked() and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	local g=e:GetLabelObject()
	Duel.SetTargetCard(g)
	g:DeleteGroup()
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_EXTRA)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetTargetsRelateToChain()
	if #mg<2 or Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_FUSION)&Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_SYNCHRO)<2
		or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_EXTRA,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local fg=g:FilterSelect(tp,s.filter1,1,1,nil,e,tp,mg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:FilterSelect(tp,s.filter2,1,1,fg,e,tp,mg)
	if #fg>0 and #sg>0 then
		Duel.SpecialSummon(fg+sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
