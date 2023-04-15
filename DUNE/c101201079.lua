--冥府の合わせ鏡
function c101201079.initial_effect(c)
	--Special Summon 1 monster, OR inflict damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101201079,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetCountLimit(1,101201079,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101201079.actcon)
	e1:SetTarget(c101201079.acttg)
	e1:SetOperation(c101201079.actop)
	c:RegisterEffect(e1)
end
function c101201079.actcon(e,tp,eg,ep,ev,re,r,rp)
	if ep==1-tp then return false end
	if (r&REASON_EFFECT)==REASON_EFFECT then
		return rp==1-tp
	else
		return Duel.GetAttacker():IsControler(1-tp)
	end
end
function c101201079.spfilter(c,e,tp,dam)
	return c:IsAttackBelow(dam) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101201079.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local is_eff=(r&REASON_EFFECT)==REASON_EFFECT
	if chk==0 then return is_eff or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101201079.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,ev))
	end
	if is_eff then
		e:SetCategory(CATEGORY_DAMAGE)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ev*2)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	end
end
function c101201079.actop(e,tp,eg,ep,ev,re,r,rp)
	if (r&REASON_EFFECT)==REASON_EFFECT then
		Duel.Damage(1-tp,ev*2,REASON_EFFECT)
		return
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101201079.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,ev)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		--End the Battle Phase after the Damage Step
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_DAMAGE_STEP_END)
		e1:SetOperation(c101201079.skop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
		Duel.RegisterEffect(e1,tp)
	end
end
function c101201079.skop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
end

