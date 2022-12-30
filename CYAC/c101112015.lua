--夢見るネムレリア
function c101112015.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(101112015)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Place 1 "Nemurelia" Continuous Spell from your Deck/GY on your field
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112015,0))
	e1:SetCategory(CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c101112015.tfcost)
	e1:SetTarget(c101112015.tftg)
	e1:SetOperation(c101112015.tfop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(101112015,ACTIVITY_SPSUMMON,c101112015.counterfilter)
	--Special Summon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e2)
	--Special Summon procedure
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCondition(c101112015.spcon)
	c:RegisterEffect(e3)
	--Banish your opponent's card(s) face-down
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101112015,1))
	e4:SetCategory(CATEGORY_REMOVE+CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(c101112015.rmtg)
	e4:SetOperation(c101112015.rmop)
	c:RegisterEffect(e4)
end
function c101112015.counterfilter(c)
	return not (c:IsCode(101112015) and c:IsFaceup())
end
function c101112015.tfcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(101112015,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101112015.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101112015.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(101112015)
end
function c101112015.tffilter(c,tp)
	return c:IsSetCard(0x292) and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c101112015.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtra() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
		and Duel.IsExistingMatchingCard(c101112015.tffilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,c,1,tp,0)
end
function c101112015.tfop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101112015.tffilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		Duel.SendtoExtraP(e:GetHandler(),tp,REASON_EFFECT)
	end
end
function c101112015.filter(c)
	return not c:IsCode(101112015)
end
function c101112015.spcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	return not Duel.IsExistingMatchingCard(c101112015.filter,tp,LOCATION_EXTRA,0,1,nil)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c101112015.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local fdg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil)
	if chk==0 then return #fdg>=3 and fdg:IsExists(Card.IsAbleToDeck,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil,tp,POS_FACEDOWN,REASON_EFFECT) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
end
function c101112015.rfilter(c)
	return not c:IsReason(REASON_REDIRECT)
end
function c101112015.tdfilter(c)
	return c:IsFacedown() and c:IsAbleToDeck()
end
function c101112015.rmop(e,tp,eg,ep,ev,re,r,rp)
	local fdg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil)
	if #fdg<3 then return end
	local ct=math.min(#fdg//3,fdg:FilterCount(Card.IsAbleToDeck,nil))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,ct,nil,tp,POS_FACEDOWN,REASON_EFFECT)
	if #g==0 then return end
	Duel.HintSelection(g,true)
	if Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)>0 then
		local oc=Duel.GetOperatedGroup():FilterCount(c101112015.rfilter,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local dg=Duel.SelectMatchingCard(tp,c101112015.tdfilter,tp,LOCATION_REMOVED,0,oc,oc,nil)
		if #dg>0 then
			Duel.BreakEffect()
			Duel.SendtoDeck(dg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
end