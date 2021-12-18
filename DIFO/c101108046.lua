--エクソシスターズ・マニフィカ
function c101108046.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c101108046.mfilter,nil,2,2)
	-- Must be Xyz Summoned
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.xyzlimit)
	c:RegisterEffect(e0)
	-- Can make a second attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	-- Banish 1 opponent card
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101108046,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1)
	e2:SetCost(c101108046.rmcost)
	e2:SetTarget(c101108046.rmtg)
	e2:SetOperation(c101108046.rmop)
	c:RegisterEffect(e2)
	-- Return material to Extra Deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101108046,1))
	e3:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c101108046.tecon)
	e3:SetTarget(c101108046.tetg)
	e3:SetOperation(c101108046.teop)
	c:RegisterEffect(e3)
end
function c101108046.mfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsRank(4) and c:IsSetCard(0x172)
end
function c101108046.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c101108046.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
end
function c101108046.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c101108046.tecon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c101108046.tefilter(c)
	return c:IsType(TYPE_XYZ) and c:IsAbleToExtra()
end
function c101108046.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetOverlayGroup():IsExists(c101108046.tefilter,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_OVERLAY)
end
function c101108046.teop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sc=c:GetOverlayGroup():FilterSelect(tp,c101108046.tefilter,1,1,nil):GetFirst()
	if not sc or Duel.SendtoDeck(sc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)<1 or not sc:IsLocation(LOCATION_EXTRA) then return end
	if sc:IsLocation(LOCATION_EXTRA) and c:IsRelateToEffect(e) and c:IsFaceup() and c:IsControler(tp)
		and c:IsCanBeXyzMaterial(sc) and sc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0
		and Duel.SelectYesNo(tp,aux.Stringid(101108046,2)) then
		Duel.BreakEffect()
		local mg=c:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(c))
		Duel.Overlay(sc,Group.FromCards(c))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end 