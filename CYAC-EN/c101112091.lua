--Gold Pride - Better Luck Next Time!
function c101112091.initial_effect(c)
	-- Add 1 "Gold Pride" monster from your Deck to your hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112091,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101112091,EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c101112091.activate)
	c:RegisterEffect(e1)
	-- Draw 1 card
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101112091,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,101112091+100)
	e2:SetCondition(c101112091.drwcon)
	e2:SetTarget(c101112091.drwtg)
	e2:SetOperation(c101112091.drwop)
	c:RegisterEffect(e2)
end
function c101112091.thfilter(c)
	return c:IsSetCard(0x192) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c101112091.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101112091.thfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(101112091,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		if Duel.SendtoHand(sg,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,sg)
			local atk=sg:GetFirst():GetAttack()
			Duel.SetLP(tp,Duel.GetLP(tp)-atk)
		end
	end
end
function c101112091.cfilter(c,tp)
	return c:IsSetCard(0x192) and c:IsPreviousSetCard(0x192) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousControler(tp) and c:IsPreviousPosition(POS_FACEUP)
		and c:IsSummonLocation(LOCATION_EXTRA) and c:IsLocation(LOCATION_EXTRA)
end
function c101112091.drwcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101112091.cfilter,1,nil,tp)
end
function c101112091.drwtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101112091.drwop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end