--厄災の星ティ・フォン
function c101202042.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,12,2,c101202042.ovfilter,aux.Stringid(101202042,0),2,c101202042.xyzop)
	c:EnableReviveLimit()
	--Neither player can activate the effects of monsters with 3000 or more ATK
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetCondition(c101202042.actlimcon)
	e1:SetValue(c101202042.aclimit)
	c:RegisterEffect(e1)
	--Return 1 monster on the field to the hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101202042,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c101202042.thcost)
	e2:SetTarget(c101202042.thtg)
	e2:SetOperation(c101202042.thop)
	c:RegisterEffect(e2)
	if not c101202042.global_check then
		c101202042.global_check=true
		local ge1=Effect.GlobalEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c101202042.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c101202042.cfilter(c,atk)
	return c:IsFaceup() and c:GetAttack()>atk
end
function c101202042.ovfilter(c,tp,xyzc)
	return c:IsFaceup() and not Duel.IsExistingMatchingCard(c101202042.cfilter,c:GetControler(),LOCATION_MZONE,0,1,nil,c:GetAttack())
end
function c101202042.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(1-tp,101202042+100)>0 end
	--Cannot Normal or Special Summon this turn
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2,tp)
	return true
end
function c101202042.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsSummonLocation(LOCATION_EXTRA) then
			local sp=tc:GetSummonPlayer()
			Duel.RegisterFlagEffect(sp,101202042,RESET_PHASE+PHASE_END,0,1)
			if Duel.GetFlagEffect(sp,101202042)>1 then
				Duel.RegisterFlagEffect(sp,101202042+100,RESET_PHASE+PHASE_END,0,2)
			end
		end
	end
end
function c101202042.actlimcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c101202042.aclimit(e,re,tp)
	return re:GetHandler():IsAttackAbove(3000) and re:IsActiveType(TYPE_MONSTER)
end
function c101202042.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c101202042.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,PLAYER_ALL,LOCATION_MZONE)
end
function c101202042.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end