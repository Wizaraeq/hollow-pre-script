--超越竜グレイスザウルス
function c100420004.initial_effect(c)
	--Synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--Cannot be destroyed by battle
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Your Dinosaur monsters Special Summoned from the GY cannot be destroyed by the opponent's effects
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c100420004.tgtg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--Opponent cannot target with effects Dinosaur monsters Special Summoned from the GY
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
	--Shuffle 1 Normal Monster from your GY into the Deck and Special Summon this card
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100420004,0))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCountLimit(1,100420004)
	e4:SetTarget(c100420004.tdtg)
	e4:SetOperation(c100420004.tdop)
	c:RegisterEffect(e4)
end
function c100420004.tgtg(e,c)
	return c:IsRace(RACE_DINOSAUR) and c:IsSummonLocation(LOCATION_GRAVE)
end
function c100420004.tdfilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsAbleToDeck()
end
function c100420004.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100420004.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function c100420004.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c100420004.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g==0 then return end
	Duel.HintSelection(g)
	local c=e:GetHandler()
	if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_DECK)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.SelectYesNo(tp,aux.Stringid(100420004,1)) then
		Duel.BreakEffect()
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end