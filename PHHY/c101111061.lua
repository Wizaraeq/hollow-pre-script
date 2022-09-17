--嫋々たる漣歌姫の壱世壊
function c101111061.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Increase ATK
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(c101111061.atktg)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--Send 1 Aqua monster from Deck to GY
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101111061,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,101111061)
	e3:SetCondition(c101111061.grcon)
	e3:SetTarget(c101111061.grtg)
	e3:SetOperation(c101111061.grop)
	c:RegisterEffect(e3)
end
function c101111061.atktg(e,c)
	return c:IsType(TYPE_FUSION) or c:IsSetCard(0x181)
end
function c101111061.cfilter(c,tp)
	return c:IsRace(RACE_AQUA) and c:IsSetCard(0x181) and c:IsControler(tp)
end
function c101111061.grcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101111061.cfilter,1,nil,tp)
end
function c101111061.grvfilter(c)
	return c:IsRace(RACE_AQUA) and c:IsLevelBelow(4) and c:IsAbleToGrave()
end
function c101111061.grtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101111061.grvfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c101111061.grop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101111061.grvfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		if tc:IsLocation(LOCATION_GRAVE) and not tc:IsSetCard(0x181) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(1,0)
			e1:SetValue(c101111061.aclimit)
			e1:SetLabel(tc:GetCode())
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c101111061.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end
