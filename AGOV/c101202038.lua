--エレキュウキ
--coded by Lyris
--Wattaurus
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--material
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xe),aux.NonTuner(Card.IsRace,RACE_THUNDER),1)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.condition)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and Duel.GetAttackTarget()==nil
end
function s.filter(c,e,tp,mg)
	return c:IsSetCard(0xe) and c:IsType(TYPE_SYNCHRO)
		and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(id)
end
function s.tfilter(c)
	return c:IsSetCard(0xe) and c:IsType(TYPE_TUNER) and c:IsAbleToDeck()
end
function s.nfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_THUNDER) and not c:IsType(TYPE_TUNER) and c:IsAbleToDeck()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(s.tfilter,tp,LOCATION_GRAVE,0,nil)
	local g2=Duel.GetMatchingGroup(s.nfilter,tp,LOCATION_MZONE,0,nil)
	g1:Merge(g2)
	if chk==0 then return #g1>0 and g1:CheckSubGroup(s.chk,2,2,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_MZONE+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.chk(g,e,tp)
	return g:GetClassCount(Card.GetLocation)==#g
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,g)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(s.tfilter,tp,LOCATION_GRAVE,0,nil)
	local mg=Duel.GetMatchingGroup(s.nfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local dg=(tg+mg):SelectSubGroup(tp,s.chk,false,2,2,e,tp)
	if not dg or Duel.SendtoDeck(dg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)<2
		or dg:IsExists(aux.NOT(Card.IsLocation),1,nil,LOCATION_DECK+LOCATION_EXTRA) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end
