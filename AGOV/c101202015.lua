--エレキハダマグロ
function c101202015.initial_effect(c)
	--Can attack directly
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	--Special Summon itself from the hand if you inflict battle damage to the opponent
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101202015,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_DAMAGE_STEP_END)
	e2:SetCountLimit(1,101202015)
	e2:SetCondition(c101202015.spcon)
	e2:SetTarget(c101202015.sptg)
	e2:SetOperation(c101202015.spop)
	c:RegisterEffect(e2)
	--Special Summon 1 "Watt" Synchro Monster from your Extra Deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101202015,1))
	e3:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCountLimit(1,101202015+100)
	e3:SetCondition(c101202015.spsynccon)
	e3:SetTarget(c101202015.spsynctg)
	e3:SetOperation(c101202015.spsyncop)
	c:RegisterEffect(e3)
	if not c101202015.global_check then
		c101202015.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLE_DAMAGE)
		ge1:SetOperation(c101202015.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c101202015.regop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if ep~=tc:GetControler() then
		Duel.RegisterFlagEffect(tc:GetControler(),101202015,RESET_PHASE+PHASE_DAMAGE,0,1)
	end
end
function c101202015.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,101202015)>0
end
function c101202015.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function c101202015.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101202015.spsynccon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and Duel.GetAttackTarget()==nil
end
function c101202015.filter(c,e)
	return c:IsLevelAbove(1) and not c:IsType(TYPE_TUNER) and c:IsReleasableByEffect(e)
		and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end
function c101202015.spfilter(c,e,tp,matg,lv)
	return c:IsSetCard(0xe) and c:IsType(TYPE_SYNCHRO)
		and c:IsLevel(lv) and Duel.GetLocationCountFromEx(tp,tp,matg,c)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101202015.rescon(sg,e,tp,mg)
	return Duel.IsExistingMatchingCard(c101202015.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,sg,sg:GetSum(Card.GetLevel)+mg:GetLevel())
end
function c101202015.spsynctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c101202015.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,e)
	if chk==0 then return c:IsLevelAbove(1) and #g>=1
		and g:CheckSubGroup(c101202015.rescon,1,#g,e,tp,c) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101202015.spsyncop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsFaceup() and c:IsRelateToEffect(e)) then return end
	local g=Duel.GetMatchingGroup(c101202015.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,e)
	if #g<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g:SelectSubGroup(tp,c101202015.rescon,false,1,#g,e,tp,c)
	if #rg~=1 then return end
	local lv=rg:GetSum(Card.GetLevel)+c:GetLevel()
	rg:AddCard(c)
	if Duel.Release(rg,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,c101202015.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil,lv):GetFirst()
		if sc then
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end