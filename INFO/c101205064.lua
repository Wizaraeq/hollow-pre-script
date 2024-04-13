--宵星の閃光
local s,id,o=GetID()
function s.initial_effect(c)
	--Make the opponent send monsters to the GY and apply effects based on the number of remaining monsters
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_RECOVER+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMING_MAIN_END+TIMINGS_CHECK_MONSTER)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectYesNo(1-tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(1-tp,Card.IsAbleToGrave,1-tp,LOCATION_MZONE,0,1,99,nil)
		if #g>0 then
			Duel.SendtoGrave(g,REASON_EFFECT,1-tp)
		end
	end
	local ct=Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_MZONE,nil)
	if ct==0 then
		--Halve your LP
		Duel.SetLP(tp,Duel.GetLP(tp)//2)
	elseif ct==1 then
		Duel.Recover(1-tp,2000,REASON_EFFECT)
	elseif ct==2 then
		local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
		if rg:GetCount()>0 then
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
			local og=Duel.GetOperatedGroup()
			local oc=og:GetFirst()
			while oc do
				oc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
				oc=og:GetNext()
			end
			og:KeepAlive()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetLabelObject(og)
			e1:SetOperation(s.retop)
			Duel.RegisterEffect(e1,tp)
		end
	elseif ct>=3 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		e1:SetValue(s.actlimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function s.retfilter(c)
	return c:GetFlagEffect(id)~=0
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(s.retfilter,nil)
	g:DeleteGroup()
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end