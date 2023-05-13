--地縛囚人 ライン・ウォーカー
function c100207019.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,100207019)
	e1:SetTarget(c100207019.thtg)
	e1:SetOperation(c100207019.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,100207019+100)
	e3:SetCondition(c100207019.tdcon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c100207019.tdtg)
	e3:SetOperation(c100207019.tdop)
	c:RegisterEffect(e3)
end
function c100207019.thfilter(c)
	return (c:IsCode(100207024) or c:IsCode(100207025)) and c:IsAbleToHand()
end
function c100207019.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100207019.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c100207019.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100207019.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c100207019.tdcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x21) and c:IsLevelAbove(6)
end
function c100207019.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100207019.tdcfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100207019.tdfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsSummonLocation(LOCATION_EXTRA) 
		and c:IsAbleToDeck()
end
function c100207019.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c100207019.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100207019.tdfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c100207019.tdfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c100207019.spfilter(c,e,tp,tc)
	return c:IsCode(tc:GetCode()) and c:IsCanBeSpecialSummoned(e,0,1-tp,false,false)
		and Duel.GetLocationCountFromEx(1-tp,1-tp,c)>0
end
function c100207019.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(c100207019.spfilter,tp,0,LOCATION_EXTRA,nil,e,tp,tc)
		if #g>0 and Duel.SelectYesNo(1-tp,aux.Stringid(100207019,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=g:Select(1-tp,1,1,nil)
			Duel.SpecialSummon(sc,0,1-tp,1-tp,false,false,POS_FACEUP)
		end
	end
end