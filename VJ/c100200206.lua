--勇気の天使ヴィクトリカ
function c100200206.initial_effect(c)
	--SS on SS
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100200206,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,100200206)
	e1:SetTarget(c100200206.sstg)
	e1:SetOperation(c100200206.ssop)
	c:RegisterEffect(e1)
	--Search on being destroyed
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100200206,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,100200206+100)
	e2:SetCondition(c100200206.thcon)
	e2:SetCost(c100200206.thcost)
	e2:SetTarget(c100200206.thtg)
	e2:SetOperation(c100200206.thop)
	c:RegisterEffect(e2)
end
function c100200206.spfilter(c,e,tp)
	return c:IsLevelAbove(5) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100200206.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100200206.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c100200206.ssop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c100200206.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
			Duel.SetLP(tp,Duel.GetLP(tp)-tc:GetTextAttack())
			--Double its ATK
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(tc:GetAttack()*2)
			tc:RegisterEffect(e1)
	end
end
function c100200206.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c100200206.remfilter(c,tp)
	return c:IsRace(RACE_FAIRY) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c100200206.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetLevel())
end
function c100200206.thfilter(c,lv)
	return c:IsRace(RACE_FAIRY) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c:IsLevel(lv)
end
function c100200206.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c100200206.remfilter,tp,LOCATION_GRAVE,0,1,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,c100200206.remfilter,tp,LOCATION_GRAVE,0,1,1,c,tp):GetFirst()
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
	e:SetLabel(tc:GetLevel())
end
function c100200206.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100200206.thop(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100200206.thfilter,tp,LOCATION_DECK,0,1,1,nil,lv)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end