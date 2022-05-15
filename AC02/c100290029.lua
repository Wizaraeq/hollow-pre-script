--Ｎｏ.２ 蚊学忍者シャドー・モスキート
function c100290029.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,2,2,nil,nil,99)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--must attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_MUST_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e3)
	--place Counter
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100290029,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c100290029.target)
	e4:SetOperation(c100290029.operation)
	c:RegisterEffect(e4)
end
aux.xyz_number[100290029]=2
function c100290029.hcounter(c)
	return c:IsFaceup() and c:GetCounter(0x1161)>0 and c:GetAttack()>0
end
function c100290029.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local con1=e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,0,LOCATION_MZONE,1,nil,0x1161,1)
	local con2=Duel.IsExistingMatchingCard(c100290029.hcounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	if chk==0 then return con1 or con2 end
	local op=0
	if con1 and con2 then
		op=Duel.SelectOption(tp,aux.Stringid(100290029,0),aux.Stringid(100290029,1))
	elseif con1 then
		op=Duel.SelectOption(tp,aux.Stringid(100290029,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(100290029,1))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_COUNTER)
		Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,tp,0x1161)
	else
		e:SetCategory(CATEGORY_DAMAGE)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
	end
end
function c100290029.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	if op==0 then
		if c:IsRelateToEffect(e) and c:RemoveOverlayCard(tp,1,1,REASON_EFFECT) then
			local cg=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,0,LOCATION_MZONE,nil,0x1161,1)
			if #cg==0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
			local tg=cg:Select(tp,1,1,nil)
			local tc=tg:GetFirst()
			Duel.HintSelection(tg)
			tc:AddCounter(0x1161,1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetCondition(c100290029.disable)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	else
		local dg=Duel.GetMatchingGroup(c100290029.hcounter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if #dg==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tg=dg:Select(tp,1,1,nil)
		local dc=tg:GetFirst()
		Duel.Damage(1-tp,dc:GetAttack(),REASON_EFFECT)
	end
end
function c100290029.disable(e)
	return e:GetHandler():GetCounter(0x1161)>0
end