--遺跡の魔鉱戦士
function c100417027.initial_effect(c)
	aux.AddCodeList(c,100417125)
	-- Cannot attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetCondition(c100417027.atkcon)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100417027,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,100417027)
	e2:SetCondition(c100417027.bravecon)
	e2:SetTarget(c100417027.sptg)
	e2:SetOperation(c100417027.spop)
	c:RegisterEffect(e2)
	--Set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100417027,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,100417027+100)
	e3:SetCondition(c100417027.setcon)
	e3:SetTarget(c100417027.settg)
	e3:SetOperation(c100417027.setop)
	c:RegisterEffect(e3)
	if not c100417027.global_check then
		c100417027.global_check=true
		local ge1=Effect.GlobalEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLE_CONFIRM)
		ge1:SetOperation(c100417027.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c100417027.check(c)
	return c and aux.IsCodeListed(c,100417125)
end
function c100417027.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c0,c1=Duel.GetBattleMonster(0)
	if c100417027.check(c0) then
		Duel.RegisterFlagEffect(0,100417027,RESET_PHASE+PHASE_END,0,1)
	end
	if c100417027.check(c1) then
		Duel.RegisterFlagEffect(1,100417027,RESET_PHASE+PHASE_END,0,1)
	end
end
function c100417027.cfilter(c)
	return c:IsCode(100417125) and c:IsFaceup()
end
function c100417027.atkcon(e)
	return not Duel.IsExistingMatchingCard(c100417027.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c100417027.bravecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100417027.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c100417027.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100417027.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100417027.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,100417027)>0
end
function c100417027.setfilter(c)
	return c:IsType(TYPE_TRAP) and aux.IsCodeListed(c,100417125) and c:IsSSetable()
end
function c100417027.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100417027.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c100417027.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c100417027.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end