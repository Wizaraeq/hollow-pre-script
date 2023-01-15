--ワナビー！
function c101112031.initial_effect(c)
	--During the End Phase, excavate and Set 1 Trap card
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112031,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCountLimit(1,101112031)
	e1:SetCost(c101112031.excvtcost)
	e1:SetTarget(c101112031.excvttg)
	e1:SetOperation(c101112031.excvtop)
	c:RegisterEffect(e1)
end
function c101112031.excvtcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c101112031.excvttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetLocationCount(1-tp,LOCATION_SZONE,PLAYER_NONE,0)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=ct end
end
function c101112031.setfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c101112031.excvtop(e,tp,eg,ep,ev,re,r,rp)
	local excct=Duel.GetLocationCount(1-tp,LOCATION_SZONE,PLAYER_NONE,0)
	Duel.ConfirmDecktop(tp,excct)
	local g=Duel.GetDecktopGroup(tp,excct)
	if #g==0 then return end
	local ct=0
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and g:IsExists(c101112031.setfilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(101112031,1)) then
	Duel.DisableShuffleCheck()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local tc=g:FilterSelect(tp,c101112031.setfilter,1,1,nil):GetFirst()
		if tc and Duel.SSet(tp,tc) then
			tc:RegisterFlagEffect(101112031,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
			--Send it to the GY during the next End Phase
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCondition(c101112031.tgcon)
			e1:SetOperation(c101112031.tgop)
			e1:SetCountLimit(1)
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetLabelObject(tc)
			e1:SetReset(RESET_PHASE+PHASE_END,2)
			Duel.RegisterEffect(e1,tp)
		end
		ct=1
	end
	local ac=#g-ct
	if ac>0 then
		Duel.SortDecktop(tp,tp,ac)
		for i=1,ac do
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
		end
	end
end
function c101112031.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetTurnCount()~=e:GetLabel() and tc:GetFlagEffect(101112031)~=0-- and tc:IsOnField() and tc:IsFacedown() --tb checked
end
function c101112031.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetLabelObject(),REASON_EFFECT)
end
