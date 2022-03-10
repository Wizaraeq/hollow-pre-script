--白銀の城のラビュリンス
--
--Script by Trishula9
function c100418014.initial_effect(c)
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c100418014.chainop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100418014,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,100418014)
	e2:SetTarget(c100418014.sttg)
	e2:SetOperation(c100418014.stop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100418014,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,100418014+100)
	e3:SetCondition(c100418014.descon)
	e3:SetTarget(c100418014.destg)
	e3:SetOperation(c100418014.desop)
	c:RegisterEffect(e3)
end
function c100418014.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():GetType()==TYPE_TRAP and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP) and ep==tp then
		Duel.SetChainLimit(c100418014.chainlm)
	end
end
function c100418014.chainlm(e,rp,tp)
	return tp==rp or not e:IsActiveType(TYPE_MONSTER)
end
function c100418014.stfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:GetType()==TYPE_TRAP and c:IsSSetable()
end
function c100418014.sttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c100418014.stfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100418014.stfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c100418014.stfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c100418014.stop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SSet(tp,tc)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCondition(c100418014.aclimit)
		tc:RegisterEffect(e1)
	end
end
function c100418014.actfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsFaceup()
end
function c100418014.aclimit(e)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsExistingMatchingCard(c100418014.actfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100418014.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetReason()&REASON_EFFECT>0
		and c:GetReasonEffect():GetHandler():GetType()==TYPE_TRAP
		and c:GetReasonEffect():IsActiveType(TYPE_TRAP) and c:GetReasonEffect():GetHandlerPlayer()==tp
end
function c100418014.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100418014.cfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c100418014.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD+LOCATION_HAND)
end
function c100418014.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(nil,tp,0,LOCATION_HAND,nil)
	local b1=#g1>0
	local b2=#g2>0
	if not (b1 or b2) then return end
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(100418014,2),aux.Stringid(100418014,3))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(100418014,2))
	else
		op=Duel.SelectOption(tp,aux.Stringid(100418014,3))+1
	end
	local sg=Group.CreateGroup()
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		sg=g1:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
	elseif op==1 then
		sg=g2:RandomSelect(tp,1)
	end
	if #sg>0 then
		Duel.Destroy(sg,REASON_EFFECT)
	end
end