--夢魔鏡の使徒－ネイロイ
function c101107018.initial_effect(c)
	aux.AddCodeList(c,74665651,1050355)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101107018,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101107018)
	e1:SetTarget(c101107018.thtg)
	e1:SetOperation(c101107018.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101107018,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)	
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,101107018+100)
	e3:SetTarget(c101107018.sptg)
	e3:SetOperation(c101107018.spop)
	c:RegisterEffect(e3)
end
function c101107018.thfilter(c)
	return c:IsCode(18189187) and c:IsAbleToHand()
end
function c101107018.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101107018.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101107018.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101107018.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		if c:IsRelateToEffect(e) and c:IsFaceup() and not c:IsAttribute(ATTRIBUTE_LIGHT) and Duel.SelectYesNo(tp,aux.Stringid(101107018,2)) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(ATTRIBUTE_LIGHT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
		end
	end
end
function c101107018.spcfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x131) and c:IsLevelAbove(1) and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(c101107018.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c)
end
function c101107018.spfilter(c,e,tp,tc)
	return c:IsSetCard(0x131) and not c:IsLevel(tc:GetLevel())
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
		and Duel.IsExistingMatchingCard(c101107018.thfilter2,tp,LOCATION_DECK,0,1,nil,c)
end
function c101107018.thfilter2(c,tc)
	return c:IsCode(74665651,1050355) and c:IsAbleToHand() and aux.IsCodeListed(tc,c:GetCode())
end
function c101107018.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.CheckReleaseGroup(tp,c101107018.spcfilter,1,c,e,tp) end
	local g=Duel.SelectReleaseGroup(tp,c101107018.spcfilter,1,1,c,e,tp)
	e:SetLabelObject(g:GetFirst())
	Duel.Release(g,REASON_COST)
end
function c101107018.spop(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetLabelObject()
	if not rc or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sc=Duel.SelectMatchingCard(tp,c101107018.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,rc):GetFirst()
	if sc then
		Duel.ConfirmCards(1-tp,sc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c101107018.thfilter2,tp,LOCATION_DECK,0,1,1,nil,sc)
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,g)
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
end