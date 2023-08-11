--炎王神天焼
function c100314025.initial_effect(c)
	--Destroy an equal number of "Fire King" monsters and opponent cards
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100314025,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100314025)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER)
	e1:SetTarget(c100314025.destg)
	e1:SetOperation(c100314025.desop)
	c:RegisterEffect(e1)
	--Replace destruction
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,100314025)
	e2:SetTarget(c100314025.reptg)
	e2:SetValue(c100314025.repval)
	e2:SetOperation(c100314025.repop)
	c:RegisterEffect(e2)
end
function c100314025.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x81)
end
function c100314025.desfilter(c,e,tp)
	return (c:IsControler(1-tp) or (c:IsFaceup() and c:IsSetCard(0x81))) and c:IsCanBeEffectTarget(e)
end
function c100314025.desrescon(sg,e,tp)
	return sg:FilterCount(Card.IsControler,nil,tp)==sg:FilterCount(Card.IsControler,nil,1-tp)
end
function c100314025.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c100314025.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c100314025.desfilter,tp,LOCATION_MZONE,LOCATION_ONFIELD,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tg=g:SelectSubGroup(tp,c100314025.desrescon,false,2,#g,e,tp)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,#tg,0,0)
end
function c100314025.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c100314025.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsOnField() and c:IsSetCard(0x81)
		and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE) 
end
function c100314025.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c100314025.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c100314025.repval(e,c)
	return c100314025.repfilter(c,e:GetHandlerPlayer())
end
function c100314025.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
