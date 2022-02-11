--神碑の穂先
function c100418029.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,100418029+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100418029.target)
	e1:SetOperation(c100418029.activate)
	c:RegisterEffect(e1)
end
function c100418029.thfilter(c)
	return c:IsSetCard(0x27e) and c:IsAbleToHand() and not c:IsCode(100418029)
end
function c100418029.spfilter(c,e,tp,ec)
	return c:IsSetCard(0x27e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,ec,c,0x60)>0
end
function c100418029.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c100418029.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c100418029.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(100418029,0),aux.Stringid(100418029,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(100418029,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(100418029,1))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end
end
function c100418029.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c100418029.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,g)
			Duel.BreakEffect()
			local rg=Duel.GetDecktopGroup(1-tp,1)
			if rg:GetCount()>0 and rg:FilterCount(Card.IsAbleToRemove,nil)==1 then
				Duel.DisableShuffleCheck()
				Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
			end
		end
	else
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c100418029.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,0x60)
			end
		end
	end
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	-- Skip next Battle Phase
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SKIP_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	if Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) then
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCondition(c100418029.skipcon)
		e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,1)
	end
	Duel.RegisterEffect(e1,tp)
end
function c100418029.skipcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end