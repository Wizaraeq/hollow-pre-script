--祈りの女王－コスモクイーン
local s,id,o=GetID()
function s.initial_effect(c)
	--Special Summon this card if a Field Spell is activated
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Target 1 Field Spell, then activate this effect based on who controls it
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetTarget(s.fieldefftg)
	e2:SetLabel(0)
	e2:SetOperation(s.fieldeffop)
	c:RegisterEffect(e2)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function s.desfilter(c,tp)
	if not c:IsFaceup() then return false end
	if c:IsControler(tp) then
		return Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_DECK,0,1,nil,c:GetCode())
	else
		return aux.NegateAnyFilter(c) and Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK,0,1,nil)
	end
end
function s.thfilter1(c,code)
	return c:IsAllTypes(TYPE_SPELL+TYPE_FIELD) and c:IsAbleToHand() and not c:IsCode(code)
end
function s.thfilter2(c)
	return c:IsAllTypes(TYPE_SPELL+TYPE_FIELD) and c:IsAbleToHand() 
end
function s.fieldefftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_FZONE) and s.desfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.desfilter,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.desfilter,tp,LOCATION_FZONE,LOCATION_FZONE,1,1,nil,tp)
	local sc=g:GetFirst()
	local code=sc:GetCode()
	if sc:GetControler()==tp and Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_DECK,0,1,1,nil,code) then
		e:SetLabel(1)
		e:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	elseif sc:GetControler()==(1-tp) and not sc:IsDisabled() and Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK,0,1,1,nil) then
		e:SetLabel(2)
		e:SetCategory(CATEGORY_DISABLE+CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	end
end
function s.fieldeffop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sc=Duel.GetFirstTarget()
	local label=e:GetLabel()
	if label==1 then
		if Duel.Destroy(sc,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_DECK,0,1,1,nil,sc:GetCode()) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g1=Duel.SelectMatchingCard(tp,s.thfilter1,tp,LOCATION_DECK,0,1,1,nil,sc:GetCode())
			if Duel.SendtoHand(g1,tp,REASON_EFFECT)>0 then
				Duel.ConfirmCards(1-tp,g1)
			end
		end
	elseif label==2 then
		if sc:IsImmuneToEffect(e) or sc:IsDisabled() or not Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK,0,1,1,nil) then return end
		Duel.NegateRelatedChain(sc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		sc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		sc:RegisterEffect(e2)
		if sc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			sc:RegisterEffect(e3)
		end
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,s.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
		if Duel.SendtoHand(g2,tp,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,g2)
		end
	end
end
