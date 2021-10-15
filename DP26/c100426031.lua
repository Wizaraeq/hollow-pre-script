--海晶乙女スプリンガール
function c100426031.initial_effect(c)
	-- Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100426031,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100426031)
	e1:SetCost(c100426031.spcost)
	e1:SetTarget(c100426031.sptg)
	e1:SetOperation(c100426031.spop)
	c:RegisterEffect(e1)
	-- Mill
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100426031,1))
	e2:SetCategory(CATEGORY_DECKDES+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,100426031+100)
	e2:SetCondition(c100426031.tgcon)
	e2:SetTarget(c100426031.tgtg)
	e2:SetOperation(c100426031.tgop)
	c:RegisterEffect(e2)
end
function c100426031.costfilter(c)
	return c:IsSetCard(0x12b) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c100426031.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100426031.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,c100426031.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c100426031.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100426031.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100426031.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_LINK and c:GetReasonCard():IsAttribute(ATTRIBUTE_WATER)
end
function c100426031.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x12b)
end
function c100426031.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c100426031.tgfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,ct)
end
function c100426031.dcfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0x12b)
end
function c100426031.tgop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c100426031.tgfilter,tp,LOCATION_MZONE,0,nil)
	if ct<1 or Duel.DiscardDeck(tp,ct,REASON_EFFECT)<1 then return end
	local g=Duel.GetOperatedGroup()
	local dc=g:FilterCount(c100426031.dcfilter,nil)
	if dc==0 then return end
	Duel.Damage(1-tp,dc*200,REASON_EFFECT)
end
