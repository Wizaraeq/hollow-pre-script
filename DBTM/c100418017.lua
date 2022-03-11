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
function c100418017.cfilter(c,tp,re,r,rp)
	return bit.band(c:GetPreviousTypeOnField(),TYPE_MONSTER)~=0 and bit.band(r,REASON_EFFECT)~=0 and rp==tp
		and re:GetHandler():GetType()==TYPE_TRAP and re:IsActiveType(TYPE_TRAP)
end
function c100418017.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100418017.cfilter,1,nil,tp,re,r,rp) and not eg:IsContains(e:GetHandler())
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
function c100418017.stfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c100418017.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==0 then return end
	local b1=Duel.IsExistingMatchingCard(c100418017.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b2=Duel.IsExistingMatchingCard(c100418017.stfilter,tp,LOCATION_HAND,0,1,nil)
	if (b1 or b2) and Duel.SelectYesNo(tp,aux.Stringid(100418017,2)) then
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(100418017,3),aux.Stringid(100418017,4))
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(100418017,3))
		else
			op=Duel.SelectOption(tp,aux.Stringid(100418017,4))+1
		end
		if op==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c100418017.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
			if #g>0 then
				Duel.BreakEffect()
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			 end
		elseif op==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local g=Duel.SelectMatchingCard(tp,c100418017.stfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
			if #g>0 then
				Duel.BreakEffect()
				Duel.SSet(tp,g)
			end
		end
	end
end