--ＴＧ グレイヴ・ブラスター
function c101202036.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_SYNCHRO),aux.NonTuner(Card.IsSynchroType,TYPE_SYNCHRO),2)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.synlimit)
	c:RegisterEffect(e0)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101202036,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetTarget(c101202036.rmtg)
	e2:SetOperation(c101202036.rmop)
	c:RegisterEffect(e2)
	--If an monster is banished, special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101202036,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,101202036+100)
	e3:SetTarget(c101202036.sstg)
	e3:SetOperation(c101202036.ssop)
	c:RegisterEffect(e3)
	--material check
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c101202036.matcon)
	e5:SetOperation(c101202036.matop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_MATERIAL_CHECK)
	e6:SetValue(c101202036.valcheck)
	e6:SetLabelObject(e5)
	c:RegisterEffect(e6)
end
c101202036.material_type=TYPE_SYNCHRO
function c101202036.mfilter(c)
	return not c:IsType(TYPE_TUNER)
end
function c101202036.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffectLabel(101202036) and e:GetHandler():GetFlagEffectLabel(101202036)>0
end
function c101202036.rmfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsSummonLocation(LOCATION_EXTRA) and c:IsAbleToRemove()
end
function c101202036.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101202036.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101202036.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and c:GetFlagEffect(101202036+100)<c:GetFlagEffectLabel(101202036) end
	c:RegisterFlagEffect(101202036+100,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c101202036.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c101202036.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c101202036.ssfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
		and c:IsCanBeEffectTarget(e) and c:IsLocation(LOCATION_REMOVED)
end
function c101202036.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c101202036.ssfilter,nil,e,tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and #g>0 end
	local c=nil
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		c=g:Select(tp,1,1,nil):GetFirst()
	else
		c=g:GetFirst()
	end
	Duel.SetTargetCard(c)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,g:GetFirst():GetLocation())
end
function c101202036.ssop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c101202036.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()>0
end
function c101202036.matop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(101202036,RESET_EVENT+RESETS_STANDARD,0,1,e:GetLabel())
end
function c101202036.valcheck(e,c)
	local g=c:GetMaterial()
	local ct=g:FilterCount(c101202036.mfilter,nil)
	e:GetLabelObject():SetLabel(ct)
end
