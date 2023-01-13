--深淵の獣アルベル
function c101112008.initial_effect(c)
	--change name
	aux.EnableChangeCode(c,68468459,LOCATION_MZONE+LOCATION_GRAVE)
	--Take control of or Special Summon 1 Dragon monster
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101112008,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,101112008)
	e2:SetCost(c101112008.cost)
	e2:SetTarget(c101112008.target)
	e2:SetOperation(c101112008.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c101112008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c101112008.tgfilter(c,e,tp,sc)
	if not (c:IsRace(RACE_DRAGON) and c:IsFaceup()) then return false end
	if c:IsLocation(LOCATION_MZONE) then
		return c101112008.ctrlfilter(c,tp,sc)
	else
		return c101112008.spfilter(c,e,tp,sc)
	end
end
function c101112008.ctrlfilter(c,tp,sc)
	return Duel.GetMZoneCount(tp,sc,tp,LOCATION_REASON_CONTROL)>0 and c:IsAbleToChangeControler()
end
function c101112008.spfilter(c,e,tp,sc)
	return Duel.GetMZoneCount(tp,sc)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101112008.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local label=e:GetLabel()
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and ((label==1 and c101112008.ctrlfilter(chkc,tp,c)) or (label==2 and c101112008.spfilter(chkc,e,tp,c))) end
	if chk==0 then return c:IsAbleToGrave() and Duel.IsExistingTarget(c101112008.tgfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil,e,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,c101112008.tgfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil,e,tp,c):GetFirst()
	if tc:IsLocation(LOCATION_MZONE) then
		e:SetLabel(1)
		e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_CONTROL)
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,tc,1,0,0)
	else
		e:SetLabel(2)
		e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,tp,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,c,1,tp,0)
end
function c101112008.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoGrave(c,REASON_EFFECT)>0 and c:IsLocation(LOCATION_GRAVE) then
		local tc=Duel.GetFirstTarget()
		if not tc:IsRelateToEffect(e) then return end
		local label=e:GetLabel()
		if label==1 then
			Duel.GetControl(tc,tp,PHASE_END,1)
		elseif label==2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end