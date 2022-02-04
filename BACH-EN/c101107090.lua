--Libromancer First Appearance
function c101107090.initial_effect(c)
	-- Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101107090+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c101107090.activate)
	c:RegisterEffect(e1)
	-- Ritual Summon
	local e2=aux.AddRitualProcGreater2(c,c101107090.filter,nil,nil,c101107090.matfilter,true)
	e2:SetDescription(aux.Stringid(101107090,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(0)
	e2:SetRange(LOCATION_FZONE)
	c:RegisterEffect(e2)
end
function c101107090.cfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c101107090.thfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x27d) and c:IsAbleToHand()
	   and not Duel.IsExistingMatchingCard(c101107090.cfilter,tp,LOCATION_ONFIELD,0,1,nil,c:GetCode())
end
function c101107090.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c101107090.thfilter,tp,LOCATION_DECK,0,nil,tp)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(101107090,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		if #sg>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function c101107090.filter(c,e,tp,chk)
	return c:IsSetCard(0x27d) and (not chk or c~=e:GetHandler())
end
function c101107090.matfilter(c,e,tp,chk)
	return not chk or c~=e:GetHandler()
end