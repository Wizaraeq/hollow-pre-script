----ヘルホーンドザウルス
function c100207003.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,100207002,c100207003.matfilter,1,true,true)
	--move field
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,100207003)
	e1:SetCondition(c100207003.con)
	e1:SetTarget(c100207003.tg)
	e1:SetOperation(c100207003.op)
	c:RegisterEffect(e1)
	--direct_attack
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_DIRECT_ATTACK)
	e12:SetCondition(c100207003.pcon)
	c:RegisterEffect(e12) 
	--summon
	local e02=Effect.CreateEffect(c)  
	e02:SetDescription(aux.Stringid(100207003,0))
	e02:SetCategory(CATEGORY_SUMMON)
	e02:SetType(EFFECT_TYPE_IGNITION)
	e02:SetRange(LOCATION_MZONE)
	e02:SetCountLimit(1,100207003+100)
	e02:SetTarget(c100207003.sumtg)
	e02:SetOperation(c100207003.sumop)
	c:RegisterEffect(e02)  
end
function c100207003.matfilter(c)
	return c:IsRace(RACE_DRAGON+RACE_DINOSAUR)
end
function c100207003.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c100207003.pfilter(c,tp)
	return not c:IsForbidden() and c:IsType(TYPE_FIELD) and c:CheckUniqueOnField(tp)
end
function c100207003.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100207003.pfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
end
function c100207003.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100207003.pfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc then Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true) end
end
function c100207003.pcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler()
	return ec:IsStatus(STATUS_SPSUMMON_TURN)
end
function c100207003.sumfilter(c)
	return c:IsRace(RACE_DRAGON+RACE_DINOSAUR) and c:IsSummonable(true,nil)
end
function c100207003.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100207003.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c100207003.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c100207003.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end