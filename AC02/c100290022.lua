--水晶ドクロ
function c100290022.initial_effect(c)
	-- Take 1000 damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100290022,0))
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c100290022.damtg)
	e1:SetOperation(c100290022.damop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	-- Add to hand or Special Summon 1 Rock monster
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100290022,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100290022)
	e2:SetCondition(c100290022.thcon)
	e2:SetTarget(c100290022.thtg)
	e2:SetOperation(c100290022.thop)
	c:RegisterEffect(e2)
	if not c100290022.global_check then
		c100290022.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(c100290022.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c100290022.checkop(e,tp,eg,ep,ev,re,r,rp)
	if bit.band(r,REASON_EFFECT)~=0 then
		Duel.RegisterFlagEffect(ep,100290022,RESET_PHASE+PHASE_END,0,1)
	end
end
function c100290022.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAttackPos() end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)
end
function c100290022.damop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Damage(tp,1000,REASON_EFFECT)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsAttackPos() then
		Duel.BreakEffect()
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	end
end
function c100290022.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,100290022)==0
end
function c100290022.thfilter(c,ft,e,tp)
	return c:IsRace(RACE_ROCK) and c:IsAttack(0)
		and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c100290022.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return Duel.IsExistingMatchingCard(c100290022.thfilter,tp,LOCATION_DECK,0,1,nil,ft,e,tp)
	end
end
function c100290022.thop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c100290022.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,ft)
	local tc=g:GetFirst()
	if tc then
		if ft>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end 