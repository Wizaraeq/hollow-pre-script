--マチュア・クロニクル
function c101203055.initial_effect(c)
	aux.AddCodeList(c,78371393)
	c:EnableCounterPermit(0x25)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Place Counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c101203055.countercon)
	e1:SetOperation(c101203055.counterop)
	c:RegisterEffect(e1)
	--effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101203055,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,101203055)
	e2:SetTarget(c101203055.efftg)
	e2:SetOperation(c101203055.effop)
	c:RegisterEffect(e2)
end
function c101203055.yubelfilter(c)
	return c:IsFaceup() and (c:IsCode(78371393) or aux.IsCodeListed(c,78371393))
end
function c101203055.countercon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101203055.yubelfilter,1,nil)
end
function c101203055.counterop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:AddCounter(0x25,1)
end
function c101203055.spfilter(c,e,tp)
	return c:IsCode(78371393) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101203055.superpolyfilter(c)
	return c:IsCode(48130397) and c:IsAbleToHand()
end
function c101203055.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsCanRemoveCounter(tp,1,0,0x25,1,REASON_COST)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c101203055.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	local b2=Duel.IsCanRemoveCounter(tp,1,0,0x25,2,REASON_COST)
		and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_REMOVED,0,1,nil)
	local b3=Duel.IsCanRemoveCounter(tp,1,0,0x25,3,REASON_COST)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,nil)
	local b4=Duel.IsCanRemoveCounter(tp,1,0,0x25,4,REASON_COST)
		and Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	local b5=Duel.IsCanRemoveCounter(tp,1,0,0x25,5,REASON_COST)
		and Duel.IsExistingMatchingCard(c101203055.superpolyfilter,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return (b1 or b2 or b3 or b4 or b5) end
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(101203055,1)},{b2,aux.Stringid(101203055,2)},{b3,aux.Stringid(101203055,3)},{b4,aux.Stringid(101203055,4)},{b5,aux.Stringid(101203055,5)})
	e:SetLabel(op)
	Duel.RemoveCounter(tp,1,0,0x25,op,REASON_COST)
	if op==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	elseif op==2 then
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
	elseif op==3 then
		e:SetCategory(CATEGORY_REMOVE)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	elseif op==4 then
		e:SetCategory(CATEGORY_DESTROY)
		local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,tp,0)
	elseif op==5 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function c101203055.effop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		--Special Summon 1 "Yubel" from your GY
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c101203055.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif op==2 then
		--Add 1 of your banished cards to your hand
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_REMOVED,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif op==3 then
		--Banish 1 card from your Deck
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	elseif op==4 then
		--Destroy 1 card on the field
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	elseif op==5 then
		--Search 1 "Super Polymerization"
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c101203055.superpolyfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end