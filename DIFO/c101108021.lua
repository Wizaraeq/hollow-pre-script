--音響戦士ディージェス
function c101108021.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	-- Flip face-up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101108021,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c101108021.postg)
	e1:SetOperation(c101108021.posop)
	c:RegisterEffect(e1)
	-- Special Summon self
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101108021,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,101108021)
	e2:SetCondition(c101108021.sspcon)
	e2:SetTarget(c101108021.ssptg)
	e2:SetOperation(c101108021.sspop)
	c:RegisterEffect(e2)
	-- Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101108021,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,101108021+100)
	e3:SetTarget(c101108021.dsptg)
	e3:SetOperation(c101108021.dspop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function c101108021.posfilter(c)
	return c:IsSetCard(0x1066) and c:IsFacedown() and c:IsDefensePos() and c:IsCanChangePosition()
end
function c101108021.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101108021.posfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,tp,0)
end
function c101108021.posop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,c101108021.posfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if #g>0 then
		Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
	end
end
function c101108021.sspcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x1066)
end
function c101108021.ssptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c101108021.sspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101108021.dspfilter(c,e,tp,pos)
	return c:IsSetCard(0x1066) and not c:IsCode(101108021) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,pos)
end
function c101108021.dsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101108021.dspfilter,tp,LOCATION_DECK,0,1,nil,e,tp,POS_FACEDOWN_DEFENSE)
		or (Duel.IsEnvironment(75304793,tp,LOCATION_FZONE) and Duel.IsExistingMatchingCard(c101108021.dspfilter,tp,LOCATION_DECK,0,1,nil,e,tp))
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101108021.dspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local a=Duel.IsExistingMatchingCard(c101108021.dspfilter,tp,LOCATION_DECK,0,1,nil,e,tp,POS_FACEDOWN_DEFENSE)
	local b=Duel.IsExistingMatchingCard(c101108021.dspfilter,tp,LOCATION_DECK,0,1,nil,e,tp,POS_FACEUP) and Duel.IsEnvironment(75304793,tp,LOCATION_FZONE)
	if b and (not a or Duel.SelectYesNo(tp,aux.Stringid(101108021,3))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c101108021.dspfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,POS_FACEUP)
		local tc=g:GetFirst()
		if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2,true)
		end
		Duel.SpecialSummonComplete()
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,c101108021.dspfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,POS_FACEDOWN_DEFENSE)
		if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)>0 then
			Duel.ConfirmCards(1-tp,sc)
		end
	end
end