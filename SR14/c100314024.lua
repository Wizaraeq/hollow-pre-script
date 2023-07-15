--炎王の聖域
function c100314024.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100314024+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c100314024.activate)
	c:RegisterEffect(e1)
	--Destruction replacement
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c100314024.desreptg)
	e2:SetValue(c100314024.desrepval)
	e2:SetOperation(c100314024.desrepop)
	c:RegisterEffect(e2)
	--Xyz Summon using only "Fire King" monsters
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100314024,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c100314024.xyzcond)
	e3:SetTarget(c100314024.xyztg)
	e3:SetOperation(c100314024.xyzop)
	c:RegisterEffect(e3)
end
function c100314024.plfilter(c,tp)
	return c:IsCode(57554544) and not c:IsForbidden()
end
function c100314024.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100314024.plfilter,tp,LOCATION_DECK,0,nil,tp)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(100314024,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if not tc then return end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	end
end
function c100314024.repfilter(c,tp)
	return c:IsControler(tp) and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and c:IsLocation(LOCATION_FZONE)
end
function c100314024.desfilter(c,e,tp)
	return c:IsControler(tp) and c:IsDestructable(e)
		and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function c100314024.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
end
function c100314024.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c100314024.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	if chk==0 then return eg:IsExists(c100314024.repfilter,1,nil,tp)
		and g:IsExists(c100314024.desfilter,1,nil,e,tp) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local sg=g:FilterSelect(tp,c100314024.desfilter,1,1,nil,e,tp)
		e:SetLabelObject(sg:GetFirst())
		Duel.HintSelection(sg,true)
		sg:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function c100314024.desrepval(e,c)
	return c100314024.repfilter(c,e:GetHandlerPlayer())
end
function c100314024.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
end
function c100314024.xyzcond(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)
end
function c100314024.xyzfilter(c,mg)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsXyzSummonable(nil,mg)
end
function c100314024.xcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x81)
end
function c100314024.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(c100314024.xcfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return #mg>0 and Duel.IsExistingMatchingCard(c100314024.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,mg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c100314024.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(c100314024.xcfilter,tp,LOCATION_MZONE,0,nil)
	if #mg==0 then return end
	local g=Duel.GetMatchingGroup(c100314024.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=g:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,sc,mg,1,#mg)
	end
end