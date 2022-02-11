--解呪の神碑
function c100418032.initial_effect(c)
	--discard
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100418032,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,100418032+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c100418032.hdcon)
	e1:SetTarget(c100418032.hdtg)
	e1:SetOperation(c100418032.hdop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100418032,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,100418032+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c100418032.sptg)
	e2:SetOperation(c100418032.spop)
	c:RegisterEffect(e2)
end
function c100418032.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c100418032.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(c100418032.cfilter,1,nil,1-tp)
end
function c100418032.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,1-tp,1)
end
function c100418032.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND,nil)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(1-tp,1)
		if Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)>0 then
			Duel.BreakEffect()
			local rg=Duel.GetDecktopGroup(1-tp,2)
			if rg:GetCount()>0 and rg:FilterCount(Card.IsAbleToRemove,nil)==2 then
				Duel.DisableShuffleCheck()
				Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
	local c=e:GetHandler()
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	-- Skip next Battle Phase
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SKIP_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	if Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) then
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCondition(c100418032.skipcon)
		e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_OPPO_TURN,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_OPPO_TURN,1)
	end
	Duel.RegisterEffect(e1,tp)
end
function c100418032.spfilter(c,e,tp,ec)
	return c:IsSetCard(0x27e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,ec,c,0x60)>0
end
function c100418032.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100418032.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c100418032.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100418032.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,0x60)
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
		e1:SetCondition(c100418032.skipcon)
		e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,1)
	end
	Duel.RegisterEffect(e1,tp)
end
function c100418032.skipcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end