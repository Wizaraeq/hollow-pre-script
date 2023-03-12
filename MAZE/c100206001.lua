--Labyrinth Heavy Tank
function c100206001.initial_effect(c)
	-- Normal Summon without Tributing
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100206001,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c100206001.ntcon)
	c:RegisterEffect(e1)
	-- Cannot attack the turn it is Normal Summoned
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c100206001.disatt)
	c:RegisterEffect(e2)
	-- Place 1 Sanga, Kazejin, or Suijin face-up in your S&T Zone as a Continuous Spell
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100206001,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,100206001)
	e3:SetTarget(c100206001.placetg)
	e3:SetOperation(c100206001.placeop)
	c:RegisterEffect(e3)
end
function c100206001.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c100206001.disatt(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--Cannot attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c100206001.plfilter(c)
	return c:IsCode(25955164,62340868,98434877) and not c:IsForbidden() and (c:IsFaceup() or not c:IsLocation(LOCATION_REMOVED))
end
function c100206001.placetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c100206001.plfilter,tp,LOCATION_REMOVED+LOCATION_HAND+LOCATION_DECK,0,1,nil) end
end
function c100206001.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x296)
end
function c100206001.placeop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c100206001.plfilter,tp,LOCATION_REMOVED+LOCATION_HAND+LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		--Treated as a Continuous Spell
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		if Duel.IsExistingMatchingCard(c100206001.filter,tp,LOCATION_ONFIELD,0,1,nil)
			and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(100206001,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
			Duel.HintSelection(sg,true)
			Duel.BreakEffect()
			Duel.Destroy(sg,REASON_EFFECT)
		end
	end
end