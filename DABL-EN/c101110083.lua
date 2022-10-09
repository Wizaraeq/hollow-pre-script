--Tilting Entrainment
function c101110083.initial_effect(c)
	--Synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	-- Special Summon 1 Level 4 or lower Pendulum monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101110083,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,101110083)
	e1:SetCondition(c101110083.spcon)
	e1:SetTarget(c101110083.sptg)
	e1:SetOperation(c101110083.spop)
	c:RegisterEffect(e1)
	-- Destroy battled monster
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101110083,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DAMAGE_STEP_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101110083+100)
	e2:SetTarget(c101110083.destg)
	e2:SetOperation(c101110083.desop)
	c:RegisterEffect(e2)
end
function c101110083.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c101110083.spfilter(c,e,tp)
	if not (c:IsType(TYPE_PENDULUM) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) then return false end
	if c:IsLocation(LOCATION_HAND) then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	else
		return c:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
	end
end
function c101110083.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101110083.spfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function c101110083.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101110083.spfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101110083.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local a,b=Duel.GetBattleMonster(tp)
	if chk==0 then return a and b and b:IsRelateToBattle() and b:IsLocation(LOCATION_MZONE)
		and (a==e:GetHandler() or (a:IsFaceup() and a:IsType(TYPE_PENDULUM))) end
	e:SetLabelObject(b)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,b,1,0,0)
end
function c101110083.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc and tc:IsRelateToBattle() and tc:IsControler(1-tp) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
