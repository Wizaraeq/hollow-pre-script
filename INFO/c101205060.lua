--罪宝の囁き
local s,id,o=GetID()
function s.initial_effect(c)
	--Return 1 Illusion or Spellcaster to the hand or Extra Deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.rttg)
	e1:SetOperation(s.rtop)
	c:RegisterEffect(e1)
	--Set this card
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.setcon)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end
function s.rtfilter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_ILLUSION+RACE_SPELLCASTER) and Duel.GetMZoneCount(tp,c)>0
		and c:IsAbleToHand()
end
function s.spfilter(c,e,tp)
	return c:IsRace(RACE_ILLUSION+RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.rttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.rtfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.rtfilter,tp,LOCATION_MZONE,0,1,nil,tp)
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,s.rtfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc:IsAbleToExtra() then
		Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,1,0,0)
	else
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.rtop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup()
		and Duel.SendtoHand(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsActivated() and re:IsActiveType(TYPE_MONSTER)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
	end
end