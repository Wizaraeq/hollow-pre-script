--白銀の城の召使い アリアンナ
--
--Script by Trishula9
function c100418017.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100418017,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,100418017)
	e1:SetTarget(c100418017.thtg)
	e1:SetOperation(c100418017.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100418017,1))
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,100418017)
	e3:SetCondition(c100418017.drcon)
	e3:SetTarget(c100418017.drtg)
	e3:SetOperation(c100418017.drop)
	c:RegisterEffect(e3)
end
function c100418017.thfilter(c)
	return c:IsSetCard(0x280) and not c:IsCode(100418017) and c:IsAbleToHand()
end
function c100418017.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100418017.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100418017.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100418017.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c100418017.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetReason()&REASON_EFFECT>0
		and c:GetReasonEffect():GetHandler():GetType()==TYPE_TRAP
		and c:GetReasonEffect():IsActiveType(TYPE_TRAP) and c:GetReasonEffect():GetHandlerPlayer()==tp
end
function c100418017.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100418017.cfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c100418017.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c100418017.spfilter(c,e,tp)
	return c:IsRace(RACE_FIEND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100418017.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		local spg=Duel.GetMatchingGroup(c100418017.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
		local stg=Duel.GetMatchingGroup(Card.IsSSetable,tp,LOCATION_HAND,0,nil)
		if ((#spg>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or #stg>0) and Duel.SelectYesNo(tp,aux.Stringid(100418017,2)) then
			local op=0
			if #spg>0 and #stg==0 then
				op=Duel.SelectOption(tp,aux.Stringid(100418017,3))+1
			end
			if #spg==0 and #stg>0 then
				op=Duel.SelectOption(tp,aux.Stringid(100418017,4))+2
			end
			if #spg>0 and #stg>0 then
				op=Duel.SelectOption(tp,aux.Stringid(100418017,3),aux.Stringid(100418017,4))+1
			end
			if op==1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=spg:Select(tp,1,1,nil)
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
			if op==2 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
				local sg=stg:Select(tp,1,1,nil)
				Duel.SSet(tp,sg)
			end
		end
	end
end