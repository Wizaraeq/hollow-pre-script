--刀皇－都牟羽沓薙
function c101112024.initial_effect(c)
	--spirit return
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	--summon with 1 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112024,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c101112024.otcon)
	e1:SetOperation(c101112024.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e2)
	--Cannot be Special Summoned
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--Opponent can send cards to the GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101112024,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c101112024.gytg)
	e2:SetOperation(c101112024.gyop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP)
	c:RegisterEffect(e3)
end
function c101112024.otfilter(c)
	return c:IsSummonType(SUMMON_TYPE_NORMAL)
end
function c101112024.otcon(e,c,minc)
	if c==nil then return true end
	local mg=Duel.GetMatchingGroup(c101112024.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	return c:IsLevelAbove(7) and minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function c101112024.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c101112024.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	local sg=Duel.SelectTribute(tp,c,1,1,mg)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c101112024.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c101112024.gyop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
	if #g>0 and Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1)
		and Duel.SelectYesNo(1-tp,aux.Stringid(101112024,2)) then
		local deck1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
		local deck2=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
		local ct=math.min(#g,deck1,deck2)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=g:Select(1-tp,1,ct,nil)
		local oc=Duel.SendtoGrave(sg,REASON_EFFECT)
		if oc>0 then
			local turn_p=Duel.GetTurnPlayer()
			Duel.Draw(turn_p,oc,REASON_EFFECT)
			Duel.Draw(1-turn_p,oc,REASON_EFFECT)
		end
	end
	--Shuffle all cards that are banished, on the field, and in the GYs into the Deck
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(101112024,3))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c101112024.tdop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)  
end
function c101112024.tdop(e,tp,eg,ep,ev,re,r,rp)
	local loc=LOCATION_ONFIELD+LOCATION_REMOVED+LOCATION_GRAVE 
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,loc,loc,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end