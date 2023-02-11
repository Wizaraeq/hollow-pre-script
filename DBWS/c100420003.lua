--超越竜ギガントザウラー
function c100420003.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsRace,RACE_DINOSAUR),aux.FilterBoolFunction(Card.IsFusionType,TYPE_NORMAL),true)
	--Add 1 Dinosaur monster from the GY to the hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100420003,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,100420003)
	e1:SetTarget(c100420003.thtg)
	e1:SetOperation(c100420003.thop)
	c:RegisterEffect(e1)
	--Shuffle 1 Normal Monster from your GY into the Deck and Special Summon this card
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100420003,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,100420003+100)
	e2:SetTarget(c100420003.tdtg)
	e2:SetOperation(c100420003.tdop)
	c:RegisterEffect(e2)
end
function c100420003.thfilter(c)
	return c:IsRace(RACE_DINOSAUR) and c:IsAbleToHand()
end
function c100420003.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c100420003.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100420003.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c100420003.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c100420003.rescon(sg,e,tp)
	return sg:FilterCount(Card.IsControler,nil,tp)==1
end
function c100420003.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0
		and tc:IsLocation(LOCATION_HAND) and e:GetHandler():IsSummonLocation(LOCATION_GRAVE) then
		Duel.ShuffleHand(tp)
		local g1=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
		local g2=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
		if #g1>0 and #g2>0 and Duel.SelectYesNo(tp,aux.Stringid(100420003,2)) then
			g1:Merge(g2)
			local dg=g1:SelectSubGroup(tp,c100420003.rescon,false,2,2,e,tp)
			if #dg>0 then
				Duel.HintSelection(dg)
				Duel.BreakEffect()
				Duel.Destroy(dg,REASON_EFFECT)
			end
		end
	end
end
function c100420003.tdfilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsAbleToDeck()
end
function c100420003.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100420003.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function c100420003.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c100420003.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g==0 then return end
	Duel.HintSelection(g)
	local c=e:GetHandler()
	if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_DECK)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.SelectYesNo(tp,aux.Stringid(100420003,3)) then
		Duel.BreakEffect()
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end