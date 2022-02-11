--黄金の雫の神碑
function c100418035.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100418035+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100418035.target)
	e1:SetOperation(c100418035.activate)
	c:RegisterEffect(e1)
end
function c100418035.spfilter(c,e,tp,ec)
	return c:IsSetCard(0x27e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,ec,c,0x60)>0
end
function c100418035.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsPlayerCanDraw(1-tp,1)
	local b2=Duel.IsExistingMatchingCard(c100418035.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(100418035,0),aux.Stringid(100418035,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(100418035,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(100418035,1))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_DRAW)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		Duel.SetTargetPlayer(1-tp)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end
end
function c100418035.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		if Duel.Draw(p,d,REASON_EFFECT)>0 then
			Duel.BreakEffect()
			local rg=Duel.GetDecktopGroup(1-tp,4)
			if rg:GetCount()>0 and rg:FilterCount(Card.IsAbleToRemove,nil)==4 then
				Duel.DisableShuffleCheck()
				Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
			end
		end
	else
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c100418035.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
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
		e1:SetCondition(c100418035.skipcon)
		e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,1)
	end
	Duel.RegisterEffect(e1,tp)
end
function c100418035.skipcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end