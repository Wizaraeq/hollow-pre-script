--星騎士 セイクリッド・カドケウス
function c101112045.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,2,nil,nil,99)
	--Add to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112045,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,101112045)
	e1:SetCondition(c101112045.thcon)
	e1:SetTarget(c101112045.thtg)
	e1:SetOperation(c101112045.thop)
	c:RegisterEffect(e1)
	--Apply the effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101112045,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101112045+100)
	e2:SetCost(c101112045.applycost)
	e2:SetTarget(c101112045.applytg)
	e2:SetOperation(c101112045.applyop)
	c:RegisterEffect(e2)
end
function c101112045.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c101112045.thfilter(c,e)
	return c:IsSetCard(0x9c,0x53) and c:IsAbleToHand() and c:IsCanBeEffectTarget(e)
end
function c101112045.rescon(sg)
	return #sg==1 or (sg:IsExists(Card.IsSetCard,1,nil,0x9c) and sg:IsExists(Card.IsSetCard,1,nil,0x53))
end
function c101112045.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c101112045.thfilter,tp,LOCATION_GRAVE,0,nil,e)
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	tg=g:SelectSubGroup(tp,c101112045.rescon,false,1,2)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,#tg,tp,0)
end
function c101112045.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c101112045.rmvfilter(c,e,tp,eg,ep,ev,re,r,rp)
	local te=c.summon_effect
	if not te then return false end
	local tg=te:GetTarget()
	return not tg or tg and tg(te,tp,eg,ep,ev,re,r,rp,0)
end
function c101112045.applycost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c101112045.applytg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return c:CheckRemoveOverlayCard(tp,1,REASON_COST)
			and Duel.IsExistingMatchingCard(c101112045.rmvfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,eg,ep,ev,re,r,rp)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101112045.rmvfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	local tc=g:GetFirst()
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
	e:SetLabelObject(tc)
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
	local tc=e:GetLabelObject()
	Duel.ClearTargetCard()
	tc:CreateEffectRelation(e)
	e:SetLabelObject(tc)
	local te=tc.summon_effect
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end
function c101112045.applyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local te=tc.summon_effect
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
