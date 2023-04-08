--ＢＫ アッパーカッター
function c100428032.initial_effect(c)
	-- Add 1 "Battlin Boxer" monster or 1 "Counter" Counter Trap from your Deck to your hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100428032,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,100428032)
	e1:SetTarget(c100428032.thtg)
	e1:SetOperation(c100428032.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	-- Special Summon or Set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100428032,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,100428032)
	e2:SetCondition(c100428032.efcon)
	e2:SetTarget(c100428032.efftg)
	e2:SetOperation(c100428032.effop)
	c:RegisterEffect(e2)
end
function c100428032.thfilter(c)
	return (c:IsSetCard(0x1084) and c:IsType(TYPE_MONSTER) or c:IsSetCard(0x299) and c:IsType(TYPE_COUNTER)) and not c:IsCode(100428032) and c:IsAbleToHand()
end
function c100428032.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100428032.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100428032.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100428032.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c100428032.efcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c100428032.spfilter(c,e,tp)
	return c:IsSetCard(0x1084) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(100428032)
end
function c100428032.setfilter(c)
	return c:IsSetCard(0x299) and c:IsType(TYPE_COUNTER) and c:IsSSetable()
end
function c100428032.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c100428032.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b2=Duel.IsExistingMatchingCard(c100428032.setfilter,tp,LOCATION_GRAVE,0,1,nil)
	if chk==0 then return b1 or b2 end
	if b1 and not b2 then
		op=Duel.SelectOption(tp,aux.Stringid(100428032,2))
	end
	if not b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(100428032,3))+1
	end
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(100428032,2),aux.Stringid(100428032,3))
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	elseif op==1 then
		e:SetCategory(0)
	end
end
function c100428032.effop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c100428032.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c100428032.setfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if #g>0 then
			Duel.SSet(tp,g)
		end
	end
end