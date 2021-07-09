--烙印の気炎
function c101106055.initial_effect(c)
	-- Send to GY, discard, and search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101106055,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_HANDES+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e1:SetCountLimit(1,101106055)
	e1:SetTarget(c101106055.target)
	e1:SetOperation(c101106055.activate)
	c:RegisterEffect(e1)
	-- Add self to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101106055,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101106055)
	e2:SetCondition(c101106055.thcon)
	e2:SetTarget(c101106055.thtg)
	e2:SetOperation(c101106055.thop)
	c:RegisterEffect(e2)
	-- Check for Fusion Monsters sent to the GY
	if not c101106055.global_check then
		c101106055.global_check=true
		local ge1=Effect.GlobalEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c101106055.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c101106055.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsType(TYPE_FUSION) and tc:IsControler(tp) then
		Duel.RegisterFlagEffect(tc:GetControler(),101106055,RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end
function c101106055.revfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and not c:IsPublic()
		and Duel.IsExistingMatchingCard(c101106055.tgfilter,tp,LOCATION_EXTRA,0,1,nil,c:GetRace())
end
function c101106055.tgfilter(c,race)
	return c:IsLevel(8) and c:IsType(TYPE_FUSION) and (c:IsAttack(2500)
		or c:IsDefense(2500)) and c:IsRace(race) and c:IsAbleToGrave()
end
function c101106055.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101106055.revfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function c101106055.thfilter(c)
	return (c:IsCode(68468459) or (aux.IsCodeListed(c,68468459) and c:IsType(TYPE_MONSTER))) and c:IsAbleToHand()
end
function c101106055.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local rg=Duel.SelectMatchingCard(tp,c101106055.revfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	if #rg==0 then return end
	Duel.ConfirmCards(1-tp,rg)
	Duel.ShuffleHand(tp)
	local cc=rg:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101106055.tgfilter,tp,LOCATION_EXTRA,0,1,1,nil,cc:GetRace())
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_GRAVE)
		and cc:IsDiscardable(REASON_EFFECT) and Duel.IsExistingMatchingCard(c101106055.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(101106055,2)) then
		Duel.BreakEffect()
		if Duel.SendtoGrave(cc,REASON_EFFECT+REASON_DISCARD)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local hg=Duel.SelectMatchingCard(tp,c101106055.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if #hg>0 then
				Duel.SendtoHand(hg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,hg)
			end
		end
	end
end
function c101106055.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,101106055)>0
end
function c101106055.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c101106055.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end